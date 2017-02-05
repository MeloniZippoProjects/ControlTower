//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "Runway.h"

Define_Module(Runway);

void Runway::initialize()
{
    runwayStatus = RunwayStatus::runway_free;

    //Throughput computation process initialization
    landedThroughputSignal = registerSignal("landedThroughputSignal");
    tookoffThroughputSignal = registerSignal("tookoffThroughputSignal");
    landingInterLeavingSignal = registerSignal("landingInterLeavingSignal");
    takeoffInterLeavingSignal = registerSignal("takeoffInterLeavingSignal");

    thTimeout = new ThroughputTimeout();
    thTimeout->setContextPointer(this);
    thTimeout->setSchedulingPriority(5);

    scheduleAt(simTime() + par("throughputCheckInterval"), thTimeout);
    landedThroughputCounter = 0U;
    tookoffThroughputCounter = 0U;

    lastLandingTime = simTime();
    lastTakeoffTime = simTime();
}

void Runway::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage()){
        if(msg->getContextPointer() == this)
        {
            //The scheduled event is a throughput timeout
            ThroughputTimeout* timeout = check_and_cast<ThroughputTimeout*>(msg);
            handleThroughputTimeout(timeout);
        }
        else
        {
            //The scheduled event is a plane to forward
            Plane* plane = check_and_cast<Plane*>(msg);
            handleOutgoingPlane(plane);
        }
    }
    else
    {
        //Incoming messages are always planes to serve
        Plane* plane = check_and_cast<Plane*>(msg);
        handleIncomingPlane(plane);
    }
}


void Runway::handleThroughputTimeout(ThroughputTimeout* timeout)
{
    emit(landedThroughputSignal, landedThroughputCounter);
    landedThroughputCounter = 0U;

    emit(tookoffThroughputSignal, tookoffThroughputCounter);
    tookoffThroughputCounter = 0U;

    scheduleAt(simTime() + par("throughputCheckInterval"), timeout);
}

void Runway::handleIncomingPlane(Plane* plane)
{
    if(runwayStatus != RunwayStatus::runway_free)
    {
        //Consistency check
        throw "Runway inconsistency: plane arrived while occupied";
    }
    else
    {
       std::string gateName = plane->getArrivalGate()->getBaseName();
       if (  gateName == "landingPlaneIn" ){
           runwayStatus = RunwayStatus::plane_landing;
           scheduleAt(simTime() + par("landingTime"), plane);
       }
       else if ( gateName == "takeoffPlaneIn" ){
           runwayStatus = RunwayStatus::plane_takeoff;
           scheduleAt(simTime() + par("takeoffTime"), plane);
       }
    }
}

void Runway::handleOutgoingPlane(Plane* plane)
{
    //Status is used to know the type of plane currently served
    switch (runwayStatus) {
        case RunwayStatus::plane_landing :
        {
            send(plane,"landingPlaneOut");
            landedThroughputCounter++;
            simtime_t interLandingTime = simTime() - lastLandingTime;
            emit(landingInterLeavingSignal, interLandingTime.dbl());
            lastLandingTime = simTime();
            break;
        }
        case RunwayStatus::plane_takeoff:
        {
            send(plane,"takeoffPlaneOut");
            tookoffThroughputCounter++;
            simtime_t interTakeoffTime = simTime() - lastTakeoffTime;
            emit(takeoffInterLeavingSignal, interTakeoffTime.dbl());
            lastTakeoffTime = simTime();
            break;
        }
        default:
            throw "Runway inconsistency: plane scheduled for exit while free";
    }

    runwayStatus = RunwayStatus::runway_free;

    //A status update is sent to the ControlTower
    UpdateRunwayFreed* update = new UpdateRunwayFreed();
    update->setSchedulingPriority(3);   //Refer to the Implementation section of Documentation
    send (update, "statusOut");
}