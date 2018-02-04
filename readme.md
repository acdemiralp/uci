**UCI**

The Universal Chess Interface (UCI) is an open chess communication protocol used by chess engines to communicate with graphical user interfaces.

This repository contains a single header implementation of the UCI protocol (April 2006) in C++11. Requires boost::signals2.

**Example Usage**
```cpp
chess_engine your_engine;
uci uci;

// Register callbacks to the messages from the UI and respond appropriately.
uci.receive_uci.connect([&]()
{
  uci.send_id("Engine name", "Author name");
  uci.send_option_uci_limit_strength(false);
  uci.send_uci_ok();
});
uci.receive_is_ready.connect([&] ()
{
  uci.send_ready_ok();
});
uci.receive_position.connect([&] (const std::string& fen, const std::vector<std::string>& moves)
{
  your_engine.set_position(fen, moves);
});
uci.receive_go.connect([&] (const std::map<uci::command, std::string>& parameters)
{
  your_engine.start_search();
});

// Start communication with the UI through console.
uci.launch();
```
