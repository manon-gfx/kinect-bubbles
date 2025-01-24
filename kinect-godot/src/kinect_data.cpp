#include "kinect_data.h"

using namespace godot;

RaiiKinect RaiiKinect::create() {
    KinectData* kinect = initializeKinect();
    return RaiiKinect(kinect);
}

// void KinectJoint::_bind_methods() {}
void KinectBody::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_valid"), &KinectBody::get_valid);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "valid", PROPERTY_HINT_NONE, ""), "", "get_valid");

    ClassDB::bind_method(D_METHOD("get_left_hand_state"), &KinectBody::get_left_hand_state);
    ClassDB::bind_method(D_METHOD("get_right_hand_state"), &KinectBody::get_right_hand_state);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "left_hand_state", PROPERTY_HINT_NONE, ""), "", "get_left_hand_state");
    ADD_PROPERTY(PropertyInfo(Variant::INT, "right_hand_state", PROPERTY_HINT_NONE, ""), "", "get_right_hand_state");
}
