#pragma once

#include <condition_variable>
#include <functional>
#include <mutex>
#include <thread>
#include <vector>

// Single-threaded task queue for serializing disk I/O off the vCPU thread.
// One DiskWorker per DiskImage ensures FILE* operations are never concurrent.
class DiskWorker {
public:
    using Task = std::function<void()>;

    DiskWorker();
    ~DiskWorker();

    DiskWorker(const DiskWorker&) = delete;
    DiskWorker& operator=(const DiskWorker&) = delete;

    void Submit(Task task);

private:
    void Run();

    std::mutex mutex_;
    std::condition_variable cv_;
    std::vector<Task> queue_;
    bool stop_ = false;
    // Must be last: the thread starts immediately and uses the members above.
    std::thread thread_;
};
