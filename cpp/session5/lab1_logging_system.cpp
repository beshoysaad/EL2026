#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>

// Log level enumeration
enum class Level { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3, FATAL = 4 };

// Log entry structure
class Log {
private:
  enum Level m_level;
  std::string m_message;

public:
  Log() = default;
  Log(Level level, std::string message) : m_level(level), m_message(message) {}
  std::string getMessage() const { return m_message; }
  Level getLevel() const { return m_level; }
  void setMessage(std::string msg) { m_message = msg; }
  void setLevel(enum Level level) { m_level = level; }
  Log &operator<<(std::string str) {
    setMessage(str);
    return *this;
  }
  bool operator==(const Log &otherLog) const {
    return m_message == otherLog.getMessage();
  }
};

std::ostream &operator<<(std::ostream &stream, const Level &lvl) {
  switch (lvl) {
  case Level::DEBUG:
    return stream << "[DEBUG]\t";
  case Level::INFO:
    return stream << "[INFO]\t";
  case Level::WARN:
    return stream << "[WARN]\t";
  case Level::ERROR:
    return stream << "[ERROR]\t";
  case Level::FATAL:
    return stream << "[FATAL]\t";
  default:
    return stream;
  }
}

std::ostream &operator<<(std::ostream &stream, const Log &log) {
  return stream << log.getLevel() << log.getMessage();
}

class LOG {
private:
  static std::vector<Log> m_logs;

public:
  static Log &Info() {
    m_logs.emplace_back();
    m_logs.back().setLevel(Level::INFO);
    return m_logs.back();
  }
  static Log &Warn() {
    m_logs.emplace_back();
    m_logs.back().setLevel(Level::WARN);
    return m_logs.back();
  }
  static Log &Error() {
    m_logs.emplace_back();
    m_logs.back().setLevel(Level::ERROR);
    return m_logs.back();
  }
  static Log &Debug() {
    m_logs.emplace_back();
    m_logs.back().setLevel(Level::DEBUG);
    return m_logs.back();
  }
  static Log &Fatal() {
    m_logs.emplace_back();
    m_logs.back().setLevel(Level::FATAL);
    return m_logs.back();
  }
  static int GetLogCount() { return m_logs.size(); }
  static bool ContainsMessage(std::string msg) {
    return std::find_if(m_logs.begin(), m_logs.end(),
                        [msg](const Log &curr) -> bool {
                          return curr.getMessage() == msg;
                        }) != m_logs.end();
  }
  static void Dump() {
    for (auto &log : m_logs) {
      if (log.getLevel() == Level::DEBUG) {
        continue;
      }
      std::cout << log << std::endl;
    }
  }
};

std::vector<Log> LOG::m_logs;

int main() {
  std::cout << "==============================================\n";
  std::cout << "           LOGGING SYSTEM VALIDATOR\n";
  std::cout << "==============================================\n\n";

  // Test : Basic logging functionality
  std::cout << "--- Test 1: Basic Logging ---\n";
  LOG::Info() << "System started";
  LOG::Warn() << "Configuration file missing";
  LOG::Error() << "Database connection failed";
  LOG::Debug() << "This debug message should not appear";
  LOG::Fatal() << "Application must terminate";

  // Verify logs were stored
  assert(LOG::GetLogCount() == 5);
  assert(LOG::ContainsMessage("System started"));
  assert(LOG::ContainsMessage("Configuration file missing"));

  LOG::Dump();

  std::cout << "\n==============================================\n";
  std::cout << "         ALL TESTS PASSED! ✓\n";
  std::cout << "==============================================\n";

  return 0;
}
