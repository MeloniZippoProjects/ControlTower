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
#include "UpdateRunwayFreed_m.h"

Define_Module(Runway);

void Runway::initialize()
{
    runwayStatus = RunwayStatus::runway_free;
}

void Runway::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage()){
        //I use status to distinguish the two types of plane
        switch (runwayStatus) {
            case RunwayStatus::plane_landing :
                send(msg,"landingPlaneOut");
                break;
            case RunwayStatus::plane_takeoff:
                send(msg,"takeoffPlaneOut");
                break;
            default:
                throw "Runway inconsistency: plane scheduled for exit while free";
        }

        runwayStatus = RunwayStatus::runway_free;
        //I send a status message to the control tower
        UpdateRunwayFreed* update = new UpdateRunwayFreed();
        update->setSchedulingPriority(3);
        send (update, "statusOut");
    }
    else
    {
        if(runwayStatus != RunwayStatus::runway_free)
        {
            throw "Runway inconcistency: plane arrived while occupied";
        }
        else
        {
            std::string gateName = msg->getArrivalGate()->getBaseName();
            //if a landingPlane arrives...
            if (  gateName == "landingPlaneIn" ){
                runwayStatus = RunwayStatus::plane_landing;
                scheduleAt(simTime() + par("landingTime"), msg);
            }

            //if a takeoffPlane arrives...
            else if ( gateName == "takeoffPlaneIn" ){
                runwayStatus = RunwayStatus::plane_takeoff;
                scheduleAt(simTime() + par("takeoffTime"), msg);
            }
        }
    }
}
