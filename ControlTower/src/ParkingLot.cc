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

#include "ParkingLot.h"

Define_Module(ParkingLot);

void ParkingLot::initialize()
{
    parkingOccupancy = registerSignal("parkingOccupancy");
    parkingInterLeaving = registerSignal("parkingInterLeaving");
    planes = 0;
    lastLeftTime = 0;
}

void ParkingLot::refreshDisplay() const
{
    char buf[32];
    sprintf(buf, "Parked planes: %d", planes);
    getDisplayString().setTagArg("t", 0, buf);
}

void ParkingLot::handleMessage(cMessage *msg)
{
    Plane* plane = check_and_cast<Plane*>(msg);

    if(msg->isSelfMessage()) //a plane scheduled for leaving
    {
        send(plane, "planeOut");
        --planes;
        simtime_t interleavingTime = simTime() - lastLeftTime;
        emit(parkingInterLeaving, interleavingTime.dbl());
        lastLeftTime = simTime();
    }
    else if(std::string(msg->getArrivalGate()->getBaseName()) == "planeIn") //a new plane has arrived
    {
        ++planes;
        scheduleAt(simTime() + par("parkingDelay") , msg);
    }

    emit(parkingOccupancy, planes);
}
