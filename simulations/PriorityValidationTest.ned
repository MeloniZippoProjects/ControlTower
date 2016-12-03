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

package controltower.simulations;

import controltower.WorkloadGenerator;
import controltower.PlaneQueue;
import controltower.ControlTower;
import controltower.Runway;

network PriorityValidationTest
{
    submodules:
        landingWG : WorkloadGenerator;
        takeoffWG : WorkloadGenerator;
        landingQueue : PlaneQueue;
        takeoffQueue : PlaneQueue;
        controlTower : ControlTower;
        runway : Runway;
		        
	connections:
	    landingWG.out --> landingQueue.planeIn;
	    landingQueue.planeOut --> runway.landingPlaneIn;
	    runway.landingPlaneOut --> landingWG.in;
	    
	    takeoffWG.out --> takeoffQueue.planeIn;
	    takeoffQueue.planeOut --> runway.takeoffPlaneIn;
	    runway.takeoffPlaneOut --> takeoffWG.in;
	    
	    landingQueue.statusOut --> controlTower.landingQueueStatusIn;
	    takeoffQueue.statusOut --> controlTower.takeoffQueueStatusIn;
	    runway.statusOut --> controlTower.runwayStatusIn;
	    controlTower.landingQueueOkOut --> landingQueue.okIn;
	    controlTower.takeoffQueueOkOut --> takeoffQueue.okIn;
}
