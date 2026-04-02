# SignalPropagation

SignalPropagation is a small MATLAB project that estimates how much a signal weakens between a transmitter and a receiver. The script models a single "transmitter–receiver" pair and calculates the signal loss at the receiver’s coordinates based on their spatial relationship. In practical terms, you provide the position of the transmitter and the position of the receiver, and the script returns the expected attenuation at that receiver location.

The core MATLAB script (`propagation.m`) focuses on a straightforward point-to-point scenario so that the inputs and outputs are easy to understand and adapt. This makes the project a useful starting point for experiments in basic radio propagation, path-loss exploration, or educational demonstrations of signal attenuation over distance.

## What this project does
- Computes signal loss for one transmitter and one receiver.
- Uses the receiver’s coordinates as the evaluation point.
- Returns a single attenuation value that represents the expected signal weakening at that location.

## Typical use case
1. Define the transmitter coordinates.
2. Define the receiver coordinates.
3. Run `propagation.m` to obtain the signal loss at the receiver’s location.

Because the project is intentionally minimal, it can be easily extended to handle multiple receivers, different propagation models, or additional environmental parameters.

## Gluten Checker UI demo
A small front-end demo has been added to make a "Gluten Checker" interface less minimal and more user-friendly.

- Open `gluten_checker.html` in a browser.
- The page uses `gluten_checker.css` for styling and includes a simple JavaScript check flow.
- The food database is illustrative only and should not be used as medical advice.
