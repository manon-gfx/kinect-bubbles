#pragma once

// Abstraction layer for MS Kinect SDK and libfreenect2
// It's a C interface with a C++ wrapper

typedef struct KinectData KinectData;

#ifdef __cplusplus
extern "C" {
#endif

KinectData* initializeKinect();
void releaseKinect(KinectData* kinect);

#ifdef __cplusplus
}

// C++ Wrapper around C interface
class RaiiKinect {
public:
    static RaiiKinect create();

    RaiiKinect(KinectData* kinect) : kinect_data(kinect) {}
    ~RaiiKinect() {
        releaseKinect(this->kinect_data);
    }

    KinectData* kinect_data = nullptr;
};

#endif
