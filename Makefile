.PHONY : clean all server client

BINDIR := bin
OBJDIR := obj
SRCDIR := src
LIBDIR := lib
XNRWOBJDIR := $(LIBDIR)/XNRW/obj
SOURCES := $(wildcard $(SRCDIR)/*.cpp)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

SERVER := $(BINDIR)/server
CLIENT := $(BINDIR)/client
SERVER_SRC := $(SRCDIR)/server.cpp
CLIENT_SRC := $(SRCDIR)/client.cpp
SERVER_OBJ := $(OBJDIR)/server.o
CLIENT_OBJ := $(OBJDIR)/client.o

XNRW_ThreadPool := $(XNRWOBJDIR)/ThreadPool.o

CXXFLAGS := --std=c++11 -O3 -D NDEBUG -lpthread -I$(LIBDIR)

all : server client

server : $(SERVER)
client : $(CLIENT)
$(XNRW_ThreadPool) :
	$(MAKE) -C $(XNRWDIR) ThreadPool -j8

$(SERVER) : $(SERVER_OBJ) $(XNRW_ThreadPool) | $(BINDIR)
	$(CXX) -o $@ $^ $(CXXFLAGS)

$(CLIENT) : $(CLIENT_OBJ) $(XNRW_ThreadPool) | $(BINDIR)
	$(CXX) -o $@ $^ $(CXXFLAGS)

$(BINDIR) :
	mkdir $@

$(OBJDIR) :
	mkdir $@

$(OBJECTS) : $(OBJDIR)/%.o : $(SRCDIR)/%.cpp | $(OBJDIR)
	$(CXX) -c -o $@ $^ $(CXXFLAGS)

clean :
	$(RM) $(OBJECTS) $(SERVER) $(CLIENT)