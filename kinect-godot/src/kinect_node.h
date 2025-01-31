#ifndef KINECT_NODE_H
#define KINECT_NODE_H

#include <godot_cpp/classes/node.hpp>

#include "kinect_data.h"

namespace godot {

class Test: public Object {
	GDCLASS(Test, Object)
protected:
	static void _bind_methods();
public:
	KinectBody body;
};

class KinectNode : public Node {
	GDCLASS(KinectNode, Node)

protected:
	static void _bind_methods();

public:
	KinectNode();
	~KinectNode();

	void _ready() override;
	void _process(double delta) override;

	void refresh_bodies(); // refresh locally cached bodies
	Ref<KinectBody> get_body(int index); // body getter

	KinectData* kinect = nullptr;
	std::vector<Ref<KinectBody>> bodies;
	bool first = true;
};

}

#endif
