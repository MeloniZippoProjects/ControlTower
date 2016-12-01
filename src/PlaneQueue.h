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

#ifndef __CONTROLTOWER_PLANEQUEUE_H_
#define __CONTROLTOWER_PLANEQUEUE_H_

#include <omnetpp.h>
#include <queue>
#include <string>
#include "Plane_m.h"
#include "UpdatePlaneEnqueued_m.h"
#include "OkToProceed_m.h"

using namespace omnetpp;
using namespace std;

class PlaneQueue : public cSimpleModule
{
  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);

    queue<Plane*> planes;
    int updatesPriority;
    simsignal_t queueTimeSignal;
    simsignal_t queueLengthSignal;
};

#endif
