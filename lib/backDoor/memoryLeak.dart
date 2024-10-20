import 'dart:math';

class MemoryHogLoop {
  void runLoopUntilMemoryExhausted() {
    List<List<int>> allocatedMemory = [];
    int allocationSize = (100 * 1024 * 1024) ~/ 4; 

    print("Starting memory allocation... Each iteration allocates approximately 100MB");

    while (true) {
      try {
        // Allocate 100MB worth of integers
        allocatedMemory.add(List<int>.generate(allocationSize, (index) => Random().nextInt(100)));
        print('Allocated ${allocatedMemory.length * 100} MB so far.');
      } catch (e) {
        print("Out of memory! Error: $e");
        break;
      }
    }

    print("Memory allocation stopped. The system ran out of memory.");
  }
}

void main() {
  MemoryHogLoop memoryHog = MemoryHogLoop();
  memoryHog.runLoopUntilMemoryExhausted();
}
