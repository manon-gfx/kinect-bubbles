#pragma once

// Abstraction layer for MS Kinect SDK and libfreenect2
// It's a C interface with a C++ wrapper

#ifdef __cplusplus
extern "C" {
#endif

typedef struct KinectData KinectData;

typedef enum KinectJointID
{
    JointID_SpineBase	= 0,
    JointID_SpineMid	= 1,
    JointID_Neck	= 2,
    JointID_Head	= 3,
    JointID_ShoulderLeft	= 4,
    JointID_ElbowLeft	= 5,
    JointID_WristLeft	= 6,
    JointID_HandLeft	= 7,
    JointID_ShoulderRight	= 8,
    JointID_ElbowRight	= 9,
    JointID_WristRight	= 10,
    JointID_HandRight	= 11,
    JointID_HipLeft	= 12,
    JointID_KneeLeft	= 13,
    JointID_AnkleLeft	= 14,
    JointID_FootLeft	= 15,
    JointID_HipRight	= 16,
    JointID_KneeRight	= 17,
    JointID_AnkleRight	= 18,
    JointID_FootRight	= 19,
    JointID_SpineShoulder	= 20,
    JointID_HandTipLeft	= 21,
    JointID_ThumbLeft	= 22,
    JointID_HandTipRight	= 23,
    JointID_ThumbRight	= 24,
    JointID_Count	= ( JointID_ThumbRight + 1 )
} KinectJointID;

typedef enum KinectHandState {
    KinectHandState_Unknown	= 0,
    KinectHandState_NotTracked	= 1,
    KinectHandState_Open	= 2,
    KinectHandState_Closed	= 3,
    KinectHandState_Lasso	= 4,
} KinectHandState;

typedef struct KinectJoint {
    float position[3];
    float orientation[4];
} KinectJoint;

typedef struct KinectBody {
    KinectHandState left_hand_state;
    KinectHandState right_hand_state;
    KinectJoint joints[JointID_Count];
} KinectBody;

KinectData* initializeKinect();
void releaseKinect(KinectData* kinect);
int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, KinectBody* result_bodies);

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
