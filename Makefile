MIX = mix

CXX = g++

CXXFLAGS = -O3 -std=c++11

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

CXXFLAGS += -I$(ERLANG_PATH)
LDFLAGS += -shared
 
ifneq ($(OS),Windows_NT)
	CXXFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

.PHONY: all clean

all:
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o priv/utils_nif.so c_src/utils_nif.cpp

clean:
	$(MIX) clean
	$(RM) priv/utils_nif.so
