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

#include "ControlTower.h"

Define_Module(ControlTower);

void ControlTower::initialize()
{
    runwayFree = true;
    landingPlanes = 0;
    takeoffPlanes = 0;

    okToProceed = new OkToProceed();
}

void ControlTower::handleMessage(cMessage *msg)
{
    string gateName = msg->getArrivalGate()->getBaseName();

    if(gateName == "landingQueueStatusIn")
        handleLandingQueueUpdate(check_and_cast<UpdatePlaneEnqueued*>(msg));
    else if(gateName == "takeoffQueueStatusIn")
        handleTakeoffQueueUpdate(check_and_cast<UpdatePlaneEnqueued*>(msg));
    else if(gateName == "runwayStatusIn")
        handleRunwayUpdate(check_and_cast<UpdateRunwayFreed*>(msg));
}

void ControlTower::handleLandingQueueUpdate(UpdatePlaneEnqueued* msg)
{
    if(runwayFree)
    {
        send(okToProceed, "landingQueueOkOut");
        runwayFree = false;
    }
    else
    {
        landingPlanes++;
    }
}

void ControlTower::handleTakeoffQueueUpdate(UpdatePlaneEnqueued* msg)
{
    if(runwayFree)
    {
        send(okToProceed, "takeoffQueueOkOut");
        runwayFree = false;
    }
    else
    {
        takeoffPlanes++;
    }
}

void ControlTower::handleRunwayUpdate(UpdateRunwayFreed* msg)
{
    if(landingPlanes == 0)
    {
        if(takeoffPlanes == 0)
        {
            runwayFree = true;
        }
        else
        {
            send(okToProceed, "takeoffQueueOkOut");
        }
    }
    else
    {
        send(okToProceed, "landingQueueOkOut");
    }
}
