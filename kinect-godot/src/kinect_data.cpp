#include "kinect_data.h"

using namespace godot;

RaiiKinect RaiiKinect::create() {
    KinectData* kinect = initializeKinect();
    return RaiiKinect(kinect);
}

void KinectBody::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_valid"), &KinectBody::get_valid);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "valid", PROPERTY_HINT_NONE, ""), "", "get_valid");

    ClassDB::bind_method(D_METHOD("get_left_hand_state"), &KinectBody::get_left_hand_state);
    ClassDB::bind_method(D_METHOD("get_right_hand_state"), &KinectBody::get_right_hand_state);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "left_hand_state", PROPERTY_HINT_NONE, ""), "", "get_left_hand_state");
    ADD_PROPERTY(PropertyInfo(Variant::INT, "right_hand_state", PROPERTY_HINT_NONE, ""), "", "get_right_hand_state");

    ClassDB::bind_method(D_METHOD("get_joint_position", "index"), &KinectBody::get_joint_position);
    ClassDB::bind_method(D_METHOD("get_joint_orientation", "index"), &KinectBody::get_joint_orientation);

    // I wish there was an easier way of doing this *cough* Rust *cough*
    BIND_ENUM_CONSTANT(JointID_SpineBase);
    BIND_ENUM_CONSTANT(JointID_SpineMid);
    BIND_ENUM_CONSTANT(JointID_Neck);
    BIND_ENUM_CONSTANT(JointID_Head);
    BIND_ENUM_CONSTANT(JointID_ShoulderLeft);
    BIND_ENUM_CONSTANT(JointID_ElbowLeft);
    BIND_ENUM_CONSTANT(JointID_WristLeft);
    BIND_ENUM_CONSTANT(JointID_HandLeft);
    BIND_ENUM_CONSTANT(JointID_ShoulderRight);
    BIND_ENUM_CONSTANT(JointID_ElbowRight);
    BIND_ENUM_CONSTANT(JointID_WristRight);
    BIND_ENUM_CONSTANT(JointID_HandRight);
    BIND_ENUM_CONSTANT(JointID_HipLeft);
    BIND_ENUM_CONSTANT(JointID_KneeLeft);
    BIND_ENUM_CONSTANT(JointID_AnkleLeft);
    BIND_ENUM_CONSTANT(JointID_FootLeft);
    BIND_ENUM_CONSTANT(JointID_HipRight);
    BIND_ENUM_CONSTANT(JointID_KneeRight);
    BIND_ENUM_CONSTANT(JointID_AnkleRight);
    BIND_ENUM_CONSTANT(JointID_FootRight);
    BIND_ENUM_CONSTANT(JointID_SpineShoulder);
    BIND_ENUM_CONSTANT(JointID_HandTipLeft);
    BIND_ENUM_CONSTANT(JointID_ThumbLeft);
    BIND_ENUM_CONSTANT(JointID_HandTipRight);
    BIND_ENUM_CONSTANT(JointID_ThumbRight);
    BIND_ENUM_CONSTANT(JointID_Count);
}
