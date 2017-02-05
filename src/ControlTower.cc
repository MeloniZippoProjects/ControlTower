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
}

void ControlTower::handleMessage(cMessage *msg)
{
    std::string gateName = msg->getArrivalGate()->getBaseName();

    if(gateName == "landingQueueStatusIn")
    {
        UpdatePlaneEnqueued* landingUpdate = check_and_cast<UpdatePlaneEnqueued*>(msg);
        handleLandingQueueUpdate(landingUpdate);
    }
    else if(gateName == "takeoffQueueStatusIn")
    {
        UpdatePlaneEnqueued* takeoffUpdate = check_and_cast<UpdatePlaneEnqueued*>(msg);
        handleTakeoffQueueUpdate(takeoffUpdate);
    }
    else if(gateName == "runwayStatusIn")
    {
        UpdateRunwayFreed* runwayUpdate = check_and_cast<UpdateRunwayFreed*>(msg);
        handleRunwayUpdate(runwayUpdate);
    }
}

void ControlTower::sendOk(std::string gate)
{
    OkToProceed* ok = new OkToProceed();
    ok->setSchedulingPriority(4);   //Refer to the Implementation section of Documentation
    send(ok, gate.c_str());
}

void ControlTower::handleLandingQueueUpdate(UpdatePlaneEnqueued* landingUpdate)
{
    if(runwayFree)
    {
        //Directly served because the runway is free.
        //A landing update is always processed before a takeoff update because of scheduling priority
        sendOk("landingQueueOkOut");
        runwayFree = false;
    }
    else
    {
        //Keep track of the pending requests to process when the runway becomes free
        landingPlanes++;
    }

    //Updates are single-use
    delete landingUpdate;
}

void ControlTower::handleTakeoffQueueUpdate(UpdatePlaneEnqueued* takeoffUpdate)
{
    if(runwayFree)
    {
        //Directly served because the runway is free.
        //A landing update is always processed before a takeoff update because of scheduling priority
        sendOk("takeoffQueueOkOut");
        runwayFree = false;
    }
    else
    {
        //Keep track of the pending requests to process when the runway becomes free
        takeoffPlanes++;
    }

    //Updates are single-use
    delete takeoffUpdate;
}

void ControlTower::handleRunwayUpdate(UpdateRunwayFreed* runwayUpdate)
{
    //If there is a pending request, it's served and the runway is kept busy.
    //Requests to land have priority.
    if(landingPlanes != 0)
    {
        sendOk("landingQueueOkOut");
        landingPlanes--;
    }
    else
    {
        if(takeoffPlanes != 0)
        {
            sendOk("takeoffQueueOkOut");
            takeoffPlanes--;
        }
        else
        {
            runwayFree = true;
        }
    }

    //Updates are single-use
    delete runwayUpdate;
}
