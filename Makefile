PROJECT := threephase

## DIRECTORIES
SRC_DIR := src
BUILD_DIR := build
DIST_DIR := dist

## LIBRARIES OUTPUT
LIB_DIST_DIR := $(DIST_DIR)/lib
LIB_SHARED := $(LIB_DIST_DIR)/lib$(PROJECT).so
LIB_STATIC := $(LIB_DIST_DIR)/lib$(PROJECT).a

## EXECUTABLES OUTPUT
BIN_DIST_DIR := $(DIST_DIR)/bin
EXECUTABLE := $(BIN_DIST_DIR)/$(PROJECT)

## SOURCES
CXX_SRC := $(shell find $(SRC_DIR) -name "*.cpp")
HXX_SRC := $(shell find $(SRC_DIR) -name "*.h")

## OBJECTS
CXX_OBJS := $(addprefix $(BUILD_DIR)/, $(patsubst src/%,%,$(patsubst %.cpp,%.o,$(CXX_SRC))))
OBJS := $(CXX_OBJS)

## INCLUDES
INCLUDE_DIRS += ./src

## LIBRARIES
LIBRARIES += pcl_common
LIBRARIES += pcl_io
LIBRARIES += pcl_filters
LIBRARIES += pcl_visualization
LIBRARIES += opencv_highgui
LIBRARIES += opencv_imgproc
LIBRARIES += opencv_core
LIBRARIES += opencv_contrib
LIBRARIES += boost_system
LIBRARIES += boost_thread
LIBRARIES += GLEW
LIBRARIES += glfw
LIBRARIES += GL
LIBRARIES += rt

###############################################################################
## COMPILER FLAGS

## COMPILER WARNINGS
WARNINGS := -Wall -Wno-sign-compare

## COMPILER FLAGS (DEBUG/RELEASE)
ifeq ($(DEBUG), 1)
	COMMON_FLAGS += -DDEBUG -g -O0
else
	COMMON_FLAGS += -DNDEBUG -O2
endif

## 
COMMON_FLAGS += $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir))

CXXFLAGS = -pthread -fPIC $(COMMON_FLAGS) $(WARNINGS)

LDFLAGS += $(foreach librarydir,$(LIBRARY_DIRS),-L$(librarydir))
LDFLAGS += $(foreach library,$(LIBRARIES),-l$(library))

###############################################################################
## TARGETS

all: $(LIB_SHARED)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(LIB_SHARED): $(OBJS)
	$(CXX) -shared -o $(TARGET) $(OBJS) $(LDFLAGS)

$(LIB_STATIC): $(OBJS)
	ar rcs $(TARGET) $(OBJS)

clean:
	rm -f $(OBJS) $(LIB_SHARED) $(LIB_STATIC)
