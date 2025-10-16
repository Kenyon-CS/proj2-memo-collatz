CXX := c++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -Wpedantic
LDFLAGS :=

BIN := bin/tests
SRCS := $(wildcard src/*.cpp) $(wildcard tests/*.cpp)
OBJS := $(SRCS:.cpp=.o)

.PHONY: all clean run test submit

all: $(BIN)

$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -Iinclude -c $< -o $@

run: all
	$(BIN)

test: run

submit: all
	@/usr/bin/env bash ./submit.sh || true

clean:
	rm -rf $(BIN) src/*.o tests/*.o
