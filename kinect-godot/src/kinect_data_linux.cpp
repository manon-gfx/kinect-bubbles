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

int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, KinectBody* result_bodies) {
    // nop
    return 0;
}

#ifdef __cplusplus
}
#endif

#endif
