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

#ifndef __CONTROLTOWER_WORKLOADGENERATOR_H_
#define __CONTROLTOWER_WORKLOADGENERATOR_H_

#include <omnetpp.h>
#include "Plane_m.h"

using namespace omnetpp;

/**
 * Implements the external environment.
 * At intervals set through a NED parameter, creates a new Plane to send to the output gate.
 * Receives Planes which completed their route through the airport from the input gate, and deletes them.
 */
class WorkloadGenerator : public cSimpleModule
{
  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);

    /**
     * Generates a Plane and sends it to the output gate.
     * Schedules the next execution of the procedur.
     */
    void generateAndSchedulePlane();

    int currentId;
};

#endif
