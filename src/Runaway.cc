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

#include "Runaway.h"

Define_Module(Runaway);

void Runaway::initialize()
{
    // TODO - Generated method body
}

void Runaway::handleMessage(cMessage *msg)
{
    //if a landingPlane arrives...
    if ( msg->getArrivalGate() == landingPlaneIn ){
        planeType = "landingPlane";
        simtime_t landingTime = 600;
        scheduleAt(simTime() + landingTime, msg);
    }

    //if a takeoffPlane arrives...
    else if ( msg->getArrivalGate() == takeoffPlaneIn ){
        planeType = "takeoffPlane";
        simtime_t takeoffTime = 600;
        scheduleAt(simTime() + takeoffTime, msg);
    }

    //if a self message arrives...
    else if (msg->isSelfMessage()){
        //I use planeType to distinguish the two types of plane
        if ( planeType == "landingPlane" ){
            send(msg,"landingPlaneOut");
        }
        else if ( planeType == "takeOffPlane" ){
            send(msg,"takeoffPlaneOut");
        }
    }
}
