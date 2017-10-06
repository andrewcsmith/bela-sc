// Note: in order to get this code to run on your machine, you must first
// download the Bela-specific SuperCollider classes from here:
//
// https://github.com/sensestage/bela-remote
// 
// You also (of course) need to have a Bela and some potentiometers.
// 

// Send to Bela computer address
~belaAddr = NetAddr.new("192.168.7.2", 57110);

// Set the default server (and s variable) to the bela
Server.default = s = Server.remote('bela', ~belaAddr);

(
  // Initialize server options
  s.options.numAnalogInChannels = 8;
  s.options.numAnalogOutChannels = 8;
  s.options.numDigitalChannels = 16;

  s.options.blockSize = 16;
  s.options.numInputBusChannels = 2;
  s.options.numOutputBusChannels = 2;
)

// initialize the default_group and run ServerTree
s.initTree;
s.startAliveThread;

// SynthDef to play a sine tone over both channels
(
  SynthDef(\sine, {
    Out.ar([0, 1], SinOsc.ar(440))
  }).send(s);
)

// Create a new instance of the sine synth
(
  x = Synth(\sine, [], s);
)

// Free the synth (stopping playback)
(
  x.free;
)

// Alternative syntax; implicit SynthDef is created and the Synth is assigned to
// global variable x.
(
x = {
  Out.ar(0, SinOsc.ar(440))
}.play(s, 1)
)

// Free the Synth
(
  x.free;
)

/* MORE TESTS. Analog stuff. */

// Attach a 1k ohm potentiometer to analog input 1. (The far right/left leads on
// the pot should connect to ground and +5V, and the center lead should connect
// to analog input slot 1.)
(
  SynthDef(\knob, {
    arg out = 0;
    Out.ar(out, SinOsc.ar( AnalogIn.ar(0).exprange(200, 5000), 0, 0.1));
  }).send(s)
)

// Instantiate the Synth
(
  k = Synth(\knob, [], s)
)

// Free the Synth
(
  k.free;
)
