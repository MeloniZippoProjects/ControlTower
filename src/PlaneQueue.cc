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

#include "PlaneQueue.h"

Define_Module(PlaneQueue);

void PlaneQueue::initialize()
{
    priority = par("priority");
}

void PlaneQueue::handleMessage(cMessage *msg)
{
    string gateName = msg->getArrivalGate()->getBaseName();

    if(gateName == "planeIn")
    {
        Plane *plane = check_and_cast<Plane*>(msg);
        plane->setEnqueueTimestamp(simTime());
        planes.push(plane);

        UpdatePlaneEnqueued* updateStatus = new UpdatePlaneEnqueued();
        updateStatus->setSchedulingPriority(priority);
        send(updateStatus, "statusOut");
    }
    else if(gateName == "okIn")
    {
        Plane *plane = planes.front();
        planes.pop();
        send(plane, "planeOut");
        delete msg;
    }
}
