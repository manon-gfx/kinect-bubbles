#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/vector4.hpp>

// Abstraction layer for MS Kinect SDK and libfreenect2
// It's a C interface with a C++ wrapper

typedef struct KinectData KinectData;

enum KinectJointID
{
    JointID_SpineBase = 0,
    JointID_SpineMid = 1,
    JointID_Neck = 2,
    JointID_Head = 3,
    JointID_ShoulderLeft = 4,
    JointID_ElbowLeft = 5,
    JointID_WristLeft = 6,
    JointID_HandLeft = 7,
    JointID_ShoulderRight = 8,
    JointID_ElbowRight = 9,
    JointID_WristRight = 10,
    JointID_HandRight = 11,
    JointID_HipLeft = 12,
    JointID_KneeLeft = 13,
    JointID_AnkleLeft = 14,
    JointID_FootLeft = 15,
    JointID_HipRight = 16,
    JointID_KneeRight = 17,
    JointID_AnkleRight = 18,
    JointID_FootRight = 19,
    JointID_SpineShoulder = 20,
    JointID_HandTipLeft = 21,
    JointID_ThumbLeft = 22,
    JointID_HandTipRight = 23,
    JointID_ThumbRight = 24,
    JointID_Count = ( JointID_ThumbRight + 1 )
};

enum KinectHandState {
    KinectHandState_Unknown = 0,
    KinectHandState_NotTracked = 1,
    KinectHandState_Open = 2,
    KinectHandState_Closed = 3,
    KinectHandState_Lasso = 4,
};

class KinectBody: public godot::RefCounted {
    GDCLASS(KinectBody, godot::RefCounted)
public:
	static void _bind_methods();

    bool valid = false;
    KinectHandState left_hand_state = KinectHandState_Unknown;
    KinectHandState right_hand_state = KinectHandState_Unknown;
    godot::Vector4 ground_plane;
    godot::Vector3 joint_positions[JointID_Count];
    godot::Vector4 joint_orientations[JointID_Count];

    int get_valid() { return valid; }
    int get_left_hand_state() { return left_hand_state; }
    int get_right_hand_state() { return right_hand_state; }
    godot::Vector4 get_ground_plane() { return ground_plane; }
    godot::Vector3 get_joint_position(unsigned int index) {
        if (index < JointID_Count) {
            return joint_positions[index];
        } else {
            return godot::Vector3();
        }
    }
    godot::Vector4 get_joint_orientation(unsigned int index) {
        if (index < JointID_Count) {
            return joint_orientations[index];
        } else {
            return godot::Vector4();
        }
    }
};

KinectData* initializeKinect();
void releaseKinect(KinectData* kinect);
int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, godot::Ref<KinectBody>* result_bodies);

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

VARIANT_ENUM_CAST(KinectJointID)
