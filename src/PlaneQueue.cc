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
    updatesPriority = par("updatesPriority");
    queueTimeSignal = registerSignal("queueTimeSignal");
    queueLengthSignal = registerSignal("queueLengthSignal");
}

void PlaneQueue::handleMessage(cMessage *msg)
{
    std::string gateName = msg->getArrivalGate()->getBaseName();
    if(gateName == "planeIn")
    {
        Plane* plane = check_and_cast<Plane*>(msg);
        handlePlane(plane);
    }
    else if(gateName == "okIn")
    {
        OkToProceed* ok = check_and_cast<OkToProceed*>(msg);
        handleOk(ok);
    }
}

void PlaneQueue::refreshDisplay() const
{
    char buf[32];
    sprintf(buf, "Queue Size: %d", planes.size());
    getDisplayString().setTagArg("t", 0, buf);
}


void PlaneQueue::handlePlane(Plane* plane)
{
    //The incoming plane is added to the queue
    plane->setEnqueueTimestamp(simTime());
    planes.push(plane);

    //The current queue length is emitted
    emit(queueLengthSignal, planes.size());

    //An update is sent to the ControlTower
    UpdatePlaneEnqueued* updateStatus = new UpdatePlaneEnqueued();
    updateStatus->setSchedulingPriority(updatesPriority);
    send(updateStatus, "statusOut");
}

void PlaneQueue::handleOk(OkToProceed* ok)
{
    //The first plane in the queue is extracted and sent out
    Plane *plane = planes.front();
    planes.pop();
    send(plane, "planeOut");

    //Current length and plane waiting time are emitted
    emit(queueLengthSignal, planes.size());
    simtime_t qTime = simTime() - plane->getEnqueueTimestamp();
    emit(queueTimeSignal, qTime.dbl());

    //Ok messages are single-use
    delete ok;
}

PlaneQueue::~PlaneQueue()
{
    while(planes.size() != 0)
    {
        delete planes.front();
        planes.pop();
    }
}
