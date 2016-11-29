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

package controltower;

network Airport
{
    @display("bgb=528,403");
    gates:
        input planeIn;
        output planeOut;


    submodules:
        landingQueue: PlaneQueue {
            @display("p=94,108");
        }
        takeoffQueue: PlaneQueue {
            @display("p=247,262");
        }
        runway: Runway {
            @display("p=247,108");
        }
        parkingLot: ParkingLot {
            @display("p=438,108");
        }
        controlTower: ControlTower {

            @display("p=94,262");
        }
    connections:
        planeIn --> landingQueue.planeIn;
        landingQueue.planeOut --> runway.landingPlaneIn;
        runway.landingPlaneOut --> parkingLot.planeIn;
        parkingLot.planeOut --> takeoffQueue.planeIn;
        takeoffQueue.planeOut --> runway.takeoffPlaneIn;
        runway.takeoffPlaneOut --> planeOut;

        controlTower.landingQueueStatusIn <-- landingQueue.statusOut;
        controlTower.takeoffQueueStatusIn <-- takeoffQueue.statusOut;
        controlTower.runwayStatusIn <-- runway.statusOut;
        controlTower.landingQueueOkOut --> landingQueue.okIn;
        controlTower.takeoffQueueOkOut --> takeoffQueue.okIn;
}
