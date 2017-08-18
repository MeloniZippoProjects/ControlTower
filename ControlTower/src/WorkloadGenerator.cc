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
    currentId = 0;

    //The first plane is created and scheduled at the start of the simulation
    generateAndSchedulePlane();
}

void WorkloadGenerator::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage()){
        //The scheduled plane is sent to the landing queue
        Plane* plane = check_and_cast<Plane*>(msg);
        send( plane , "out" );

        //Rescheduling
        generateAndSchedulePlane();
    }
    else{
        //Planes that completed the path through the airport are deleted
        Plane* plane = check_and_cast<Plane*>(msg);
        delete plane;
    }
}

void WorkloadGenerator::generateAndSchedulePlane()
{
    Plane* newPlane = new Plane("", currentId++);
    newPlane->setSchedulingPriority(0);     //Refer to the Implementation section of Documentation
    newPlane->setContextPointer(nullptr);

    scheduleAt( simTime() + par("interArrivalTime") , newPlane );
}
