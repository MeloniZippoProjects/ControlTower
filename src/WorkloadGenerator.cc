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

#include "WorkloadGenerator.h"

Define_Module(WorkloadGenerator);

void WorkloadGenerator::initialize()
{
    //I create a new plane and send it as a self message at the start of the simulation
    currentId = 0;

    Plane* newPlane = createPlane();
    scheduleAt( par("interArrivalTime") , newPlane );
}

void WorkloadGenerator::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage()){

        //I send the plane to the landingQueue
        send( msg , "out" );


        //I create another plane
        Plane *newPlane = createPlane();
        scheduleAt( simTime() + par("interArrivalTime") , newPlane );


    }
    else{
        //I delete the plane
        delete msg;
    }
}

Plane* WorkloadGenerator::createPlane()
{
    Plane* newPlane = new Plane("", currentId++);
    newPlane->setSchedulingPriority(0);

    return newPlane;
}
