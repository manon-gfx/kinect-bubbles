#include "kinect_data.h"

RaiiKinect RaiiKinect::create() {
    KinectData* kinect = initializeKinect();
    return RaiiKinect(kinect);
}
