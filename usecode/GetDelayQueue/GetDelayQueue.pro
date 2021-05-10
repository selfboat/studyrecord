QT -= gui

CONFIG += c++11 console
CONFIG -= app_bundle

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS


# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += \
    BasicUsageEnvironment/BasicHashTable.cpp \
    BasicUsageEnvironment/BasicTaskScheduler.cpp \
    BasicUsageEnvironment/BasicTaskScheduler0.cpp \
    BasicUsageEnvironment/BasicTaskSchedulerEpoll.cpp \
    BasicUsageEnvironment/BasicUsageEnvironment.cpp \
    BasicUsageEnvironment/BasicUsageEnvironment0.cpp \
    BasicUsageEnvironment/DelayQueue.cpp \
    Common/trace.cpp \
    UsageEnvironment/HashTable.cpp \
    UsageEnvironment/UsageEnvironment.cpp \
    UsageEnvironment/strDup.cpp \
    main.cpp



# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += BasicUsageEnvironment/include/ \
              UsageEnvironment/include/  \
              Common \



HEADERS += \
    BasicUsageEnvironment/include/BasicHashTable.hh \
    BasicUsageEnvironment/include/BasicTaskSchedulerEpoll.h \
    BasicUsageEnvironment/include/BasicUsageEnvironment.hh \
    BasicUsageEnvironment/include/BasicUsageEnvironment0.hh \
    BasicUsageEnvironment/include/BasicUsageEnvironment_version.hh \
    BasicUsageEnvironment/include/DelayQueue.hh \
    BasicUsageEnvironment/include/HandlerSet.hh \
    Common/NetCommon.h \
    Common/trace.h \
    UsageEnvironment/include/Boolean.hh \
    UsageEnvironment/include/HashTable.hh \
    UsageEnvironment/include/UsageEnvironment.hh \
    UsageEnvironment/include/UsageEnvironment_version.hh \
    UsageEnvironment/include/strDup.hh


