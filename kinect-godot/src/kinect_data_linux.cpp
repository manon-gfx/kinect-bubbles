#ifndef _WIN32

using namespace godot;

struct KinectData {
    int dummy;
};

KinectData* initializeKinect() {
    return nullptr;
}
void releaseKinect(KinectData* kinect) {
    // nop
}

int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, godot::Ref<KinectBody>* result_bodies) {
    // nop
    return 0;
}

#endif
