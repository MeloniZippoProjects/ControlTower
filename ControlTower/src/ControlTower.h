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

#ifndef __CONTROLTOWER_CONTROLTOWER_H_
#define __CONTROLTOWER_CONTROLTOWER_H_

#include <omnetpp.h>
#include <string.h>
#include "UpdatePlaneEnqueued_m.h"
#include "UpdateRunwayFreed_m.h"
#include "OkToProceed_m.h"

using namespace omnetpp;

/**
 * Implements the ControlTower node. 
 * Receives UpdatePlaneEnqueued messages from the landing and takeoff PlaneQueues, 
 * and UpdateRunwayFreed messages from the Runway.
 * Sends OkToProceed messages to the PlaneQueues, according to the priority policy.
 */
class ControlTower : public cSimpleModule
{
  private:
    bool runwayFree;
    int landingPlanes;
    int takeoffPlanes;

  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);

    /**
     * Creates and sends an OkToProceed message to the specified gate.
     */
    void sendOk(std::string gate);

    /**
     * Handles an UpdatePlaneEnqueued message from the landing PlaneQueue.
     */
    void handleLandingQueueUpdate(UpdatePlaneEnqueued* msg);
    
    /**
     * Handles an UpdatePlaneEnqueued message from the takeoff PlaneQueue.
     */
    void handleTakeoffQueueUpdate(UpdatePlaneEnqueued* msg);
    
    /**
     * Handles an UpdateRunwayFreed message from the Runway.
     */
    void handleRunwayUpdate(UpdateRunwayFreed* msg);
};

#endif
