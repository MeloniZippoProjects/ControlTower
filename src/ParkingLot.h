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

#ifndef __CONTROLTOWER_PARKINGLOT_H_
#define __CONTROLTOWER_PARKINGLOT_H_

#include <omnetpp.h>
#include <string>

#include "Plane_m.h"

using namespace omnetpp;
using namespace std;

/**
 * Implements the ParkingLot node.
 * Receives Plane messages from the input gate and sends them to the output gate after a timeout.
 * The timeout duration is set through a NED parameter.
 */
class ParkingLot : public cSimpleModule
{
  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void refreshDisplay() const;    // Used to show the number of enqueued planes in graphical environment.

    int planes;
    simsignal_t parkingOccupancy;
    simsignal_t parkingInterLeaving;

    simtime_t lastLeftTime;
};

#endif
