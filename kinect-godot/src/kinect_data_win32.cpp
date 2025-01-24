#ifdef _WIN32 // Windows based platforms only

#include <Kinect.h>

#include "kinect_data.h"
#include "logging.h"

#define CRASH() (*(volatile int*)0 = 1337)
#define ASSERT(x, msg, ...) do {                                               \
    if (!(x)) {                                                                \
        log_error(                                                             \
            "Assertion (%s) failed in file %s on line %d. function: %s",       \
            #x, __FILE__, __LINE__, __func__);                                 \
        CRASH();                                                               \
    }                                                                          \
} while (false)
#define MIN(a, b) ((a) < (b) ? (a) : (b))

struct KinectData {
    IKinectSensor* kinect;

    ICoordinateMapper* coord_mapper;

    IBodyFrameSource* body_frame_source;
    IBodyFrameReader* body_frame_reader;
};

#ifdef __cplusplus
extern "C" {
#endif

KinectData* initializeKinect() {
    IKinectSensor* kinect = nullptr;
    HRESULT hr = GetDefaultKinectSensor(&kinect);
    if (FAILED(hr)) {
        log_error("Failed to get the default kinect sensor :(. HRESULT: 0x%x", hr);
        return nullptr;
    }
    ASSERT(kinect != nullptr, "Kinect seemed to initialize fine, but the pointer was null :(");

    hr = kinect->Open();
    if (FAILED(hr)) {
        log_error("Failed to open kinect sensor :(. HRESULT: 0x%x", hr);
        kinect->Release();
        return nullptr;
    }

    IBodyFrameSource* body_frame_source = nullptr;
    hr = kinect->get_BodyFrameSource(&body_frame_source);
    if (FAILED(hr)) {
        log_error("Failed to open body frame source :(. HRESULT: 0x%x", hr);
        kinect->Close();
        kinect->Release();
        return nullptr;
    }

    IBodyFrameReader* body_frame_reader = nullptr;
    hr = body_frame_source->OpenReader(&body_frame_reader);
    if (FAILED(hr)) {
        log_error("Failed to open body frame reader :(. HRESULT: 0x%x", hr);
        body_frame_source->Release();
        kinect->Close();
        kinect->Release();
        return nullptr;
    }

    KinectData *result = (KinectData*)calloc(1, sizeof(KinectData));
    result->kinect = kinect;
    result->body_frame_source = body_frame_source;
    result->body_frame_reader = body_frame_reader;
    return result;
}

void releaseKinect(KinectData* kinect) {
    if (kinect == nullptr) {
        return;
    }

    if (kinect->body_frame_source) {
        kinect->body_frame_source->Release();
    }

    if (kinect->body_frame_reader) {
        kinect->body_frame_reader->Release();
    }

    if (kinect->kinect) {
        kinect->kinect->Release();
    }

    free(kinect);
}

int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, KinectBody* result_bodies) {
    IBodyFrame* body_frame;
    kinect->body_frame_reader->AcquireLatestFrame(&body_frame);

    body_capacity = MIN(body_capacity, 4);

    IBody* bodies[4];
    body_frame->GetAndRefreshBodyData(body_capacity, bodies);

    int body_count = 0;
    for (int i = 0; i < body_capacity; ++i) {
        if (bodies[i] == nullptr) {
            break;
        }
        KinectBody* result_body = &result_bodies[i];

        HandState left_hand_state;
        bodies[i]->get_HandLeftState(&left_hand_state);
        result_body->left_hand_state = (KinectHandState)left_hand_state;

        HandState right_hand_state;
        bodies[i]->get_HandRightState(&right_hand_state);
        result_body->right_hand_state = (KinectHandState)right_hand_state;

        Joint joints[JointType_Count];
        bodies[i]->GetJoints(JointType_Count, joints);

        JointOrientation joint_orientations[JointType_Count];
        bodies[i]->GetJointOrientations(JointType_Count, joint_orientations);

        for (int j = 0; j < JointType_Count; ++j) {
            int joint_type = joints[j].JointType;
            result_body->joints[joint_type].position[0] = joints[j].Position.X;
            result_body->joints[joint_type].position[1] = joints[j].Position.Y;
            result_body->joints[joint_type].position[2] = joints[j].Position.Z;

            joint_type = joint_orientations[j].JointType;
            result_body->joints[joint_type].orientation[0] = joint_orientations[j].Orientation.x;
            result_body->joints[joint_type].orientation[1] = joint_orientations[j].Orientation.y;
            result_body->joints[joint_type].orientation[2] = joint_orientations[j].Orientation.z;
            result_body->joints[joint_type].orientation[2] = joint_orientations[j].Orientation.w;
        }
        body_count += 1;
    }

    return body_count;
}

#ifdef __cplusplus
}
#endif

#endif
