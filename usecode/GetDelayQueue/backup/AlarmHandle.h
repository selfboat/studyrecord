#ifndef ALARMHANDLE_H
#define ALARMHANDLE_H

#include "DelayQueue.hh"
#include "UsageEnvironment.hh"

/**
 * @brief 延时调度的处理单元类
 */
class AlarmHandler: public DelayQueueEntry {
public:
  AlarmHandler(TaskFunc* proc, void* clientData, DelayInterval timeToDelay)
    : DelayQueueEntry(timeToDelay), fProc(proc), fClientData(clientData) {
  }

private: // redefined virtual functions
  virtual void handleTimeout() {
    (*fProc)(fClientData);
    DelayQueueEntry::handleTimeout();
  }

private:
  TaskFunc* fProc;
  void* fClientData;
};


#endif // ALARMHANDLE_H
