#ifdef _WIN32 // Windows based platforms only

#include <Kinect.h>

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

struct KinectData {
    IKinectSensor* kinect;
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

    KinectData *result = (KinectData*)calloc(1, sizeof(KinectData));
    result->kinect = kinect;
    return result;
}

void releaseKinect(KinectData* kinect) {
    if (kinect == nullptr) {
        return;
    }

    if (kinect->kinect) {
        kinect->kinect->Release();
    }

    free(kinect);
}

#ifdef __cplusplus
}
#endif

#endif
