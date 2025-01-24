#include "kinect_node.h"
#include "logging.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Test::_bind_methods() {

}

void KinectNode::_bind_methods() {
    ClassDB::bind_method(D_METHOD("test", "value"), &KinectNode::test);
    ClassDB::bind_method(D_METHOD("get_body"), &KinectNode::get_body);
}

KinectNode::KinectNode() {
	// Initialize any variables here.
}

KinectNode::~KinectNode() {
	// Add your cleanup here.

    log_error("Closing kinect");
    releaseKinect(this->kinect);
}

void KinectNode::_ready() {
    log_error("Looking for a kinect");
    this->kinect = initializeKinect();
    this->first = false;
    if (this->kinect == nullptr) {
        log_error("No kinect found :(");
    } else {
        log_error("Found a kinect :D %p", this->kinect);
    }
}

Test* KinectNode::test(float value) {
    // log_error("test! %f", value);

    return nullptr;
}

Ref<KinectBody> KinectNode::get_body() {
    Ref<KinectBody> result;

    if (this->kinect) {
        result.instantiate();
        fetchKinectBodies(this->kinect, 1, result.ptr());
    } else {
        log_error("no kinect :(");
    }

    return result;
}

void KinectNode::_process(double delta) {
    // // Try to init the kinect once
    // if (this->first) {

    // }
}
