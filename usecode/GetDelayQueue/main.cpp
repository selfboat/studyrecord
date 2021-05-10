#include <QCoreApplication>
#include "BasicUsageEnvironment.hh"

char eventLoopWatchVariable = 0;
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    // Begin by setting up our usage environment:
    TaskScheduler* scheduler = BasicTaskScheduler::createNew();
    UsageEnvironment* env = BasicUsageEnvironment::createNew(*scheduler);

    // All subsequent activity takes place within the event loop:
    env->taskScheduler().doEventLoop(&eventLoopWatchVariable);
    // This function call does not return, unless, at some point in time, "eventLoopWatchVariable" gets set to something non-zero.

    return 0;

    return a.exec();
}

