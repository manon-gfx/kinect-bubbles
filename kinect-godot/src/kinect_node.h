#ifndef KINECT_NODE_H
#define KINECT_NODE_H

#include <godot_cpp/classes/node.hpp>

#include "kinect_data.h"

namespace godot {

class KinectNode : public Node {
	GDCLASS(KinectNode, Node)

protected:
	static void _bind_methods();

public:
	KinectNode();
	~KinectNode();

	void _process(double delta) override;

	KinectData* kinect = nullptr;
	bool first = true;
};

}

#endif
