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

int fetchKinectBodies(KinectData* kinect, unsigned int body_capacity, godot::Ref<KinectBody>* result_bodies) {
    body_capacity = MIN(body_capacity, BODY_COUNT);

    IBodyFrame* body_frame = nullptr;
    HRESULT hr = kinect->body_frame_reader->AcquireLatestFrame(&body_frame);
    if (FAILED(hr)) {
        return 0;
    }
    ASSERT(body_frame, "Failed to get a body frame :( NULL");

    Vector4 kinect_ground_plane = {};
    hr = body_frame->get_FloorClipPlane(&kinect_ground_plane);
    godot::Vector4 ground_plane;
    if (SUCCEEDED(hr)) {
        ground_plane.x = kinect_ground_plane.x;
        ground_plane.y = kinect_ground_plane.y;
        ground_plane.z = -kinect_ground_plane.z; // left to right handed
        ground_plane.w = kinect_ground_plane.w;
    }

    IBody* bodies[BODY_COUNT] = {};
    hr = body_frame->GetAndRefreshBodyData(BODY_COUNT, bodies);
    if (FAILED(hr)) {
        log_error("Failed to get and refresh body data hr 0x%x", hr);
        body_frame->Release();
        return 0;
    }

    int body_count = 0;
    for (int i = 0; i < BODY_COUNT; ++i) {
        if (bodies[i] == nullptr) {
            continue;
        }

        KinectBody* result_body = result_bodies[i].ptr();

        BOOLEAN is_tracked = FALSE;
        HRESULT hr = bodies[i]->get_IsTracked(&is_tracked);
        result_body->valid = SUCCEEDED(hr) && is_tracked;

        if (result_body->valid) {
            result_body->ground_plane = ground_plane;

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
                result_body->joint_positions[joint_type].x = joints[j].Position.X;
                result_body->joint_positions[joint_type].y = joints[j].Position.Y;
                result_body->joint_positions[joint_type].z = -joints[j].Position.Z; // left handed to right handed

                // TODO(manon): Left handed to right handed conversion?
                joint_type = joint_orientations[j].JointType;
                result_body->joint_orientations[joint_type].x = joint_orientations[j].Orientation.x;
                result_body->joint_orientations[joint_type].y = joint_orientations[j].Orientation.y;
                result_body->joint_orientations[joint_type].z = joint_orientations[j].Orientation.z;
                result_body->joint_orientations[joint_type].w = joint_orientations[j].Orientation.w;
            }

            result_body->valid = true;
            body_count += 1;
        }
    }

    for (int i = 0; i < BODY_COUNT; ++i) {
        if (bodies[i] != nullptr) {
            bodies[i]->Release();
        }
    }

    body_frame->Release();
    return body_count;
}

#endif
