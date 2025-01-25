#include "kinect_node.h"
#include "logging.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Test::_bind_methods() {

}

void KinectNode::_bind_methods() {
    ClassDB::bind_method(D_METHOD("refresh_bodies"), &KinectNode::refresh_bodies);
    ClassDB::bind_method(D_METHOD("get_body", "index"), &KinectNode::get_body);
}

KinectNode::KinectNode() {
	// Initialize any variables here.
    for (int i = 0; i < 6; ++i) {
        Ref<KinectBody> body;
        body.instantiate();
        this->bodies.push_back(body);
    }
}

KinectNode::~KinectNode() {
	// Add your cleanup here.
    log_error("Closing kinect");
    releaseKinect(this->kinect);
}

void KinectNode::_ready() {
    log_error("Looking for a kinect . . .");
    this->kinect = initializeKinect();
    this->first = false;
    if (this->kinect == nullptr) {
        log_error("No kinect found :(");
    } else {
        log_error("Found a kinect :D %p", this->kinect);
    }
}

void KinectNode::refresh_bodies() {
    if (this->kinect) {
        fetchKinectBodies(this->kinect, this->bodies.size(), this->bodies.data());
    } else {
        // log_error("no kinect :(");
    }
}
Ref<KinectBody> KinectNode::get_body(int index) {
    return this->bodies[index];
}

void KinectNode::_process(double delta) {
    this->refresh_bodies();
}
