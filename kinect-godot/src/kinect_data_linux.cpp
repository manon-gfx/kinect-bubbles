#ifndef _WIN32

struct KinectData {
    int dummy;
};

#ifdef __cplusplus
extern "C" {
#endif

KinectData* initializeKinect() {
    return nullptr;
}
void releaseKinect(KinectData* kinect) {
    // nop
}

#ifdef __cplusplus
}
#endif

#endif
