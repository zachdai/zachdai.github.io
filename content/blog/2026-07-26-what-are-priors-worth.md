---
title: "What Are Our Priors Worth?"
date: "2026-07-26"
author: "Zach Dai"
blogCategory: "Reading Notes & Thoughts" # "Mathematics" → "Machine Learning" → "Reading Notes & Thoughts" → "Tools"
---

A few days ago I finally got a masked autoencoder to work. An earlier attempt hadn't, where downstream classification and regression accuracy are about random choice. After digging through the difference between the two runs, the answer turned out to be almost embarrassingly small: the working version added loudness normalization as a preprocessing step. One line of human judgment, baked in before a single gradient step, was the difference between a useless encoder and a working one.

That sent me down a rabbit hole: how much is our experience, or our accumulated human bias about how to set up a problem, actually worth, in an era where the dominant story is that scale eats expertise?

## Why normalization can make an encoder

It's worth being precise about why loudness normalization mattered so much, because the mechanism matters for the argument that follows.

An MAE's objective is reconstruction error, usually something like pixel, or amplitude-level MSE over masked patches. That loss doesn't know or care what you plan to do with the representation afterward. If loudness varies a lot across your training data and contributes disproportionately to reconstruction error, the model will happily spend a large share of its capacity encoding loudness, because that's the cheapest way to drive the loss down. Whatever fine-grained structure like the stuff useful for your downstream classification or regression task you actually wanted gets comparatively starved of representational capacity. It's not that the information isn't there in the data; it's that the objective doesn't point at it.

Normalizing loudness away removes a high-variance, task-irrelevant confound from the loss surface, and the model's capacity has nowhere left to go but toward the structure you actually care about. This isn't injecting new information into the model but correcting a mismatch between the proxy objective (reconstruction) and the real target (a useful representation).

## Two kinds of prior

I think this points to a distinction that gets flattened whenever people invoke "the bitter lesson" as a blanket argument that human priors are on their way out.

Priors that substitute for missing statistical strength. Early NLP leaned heavily on linguists — hand-built phoneme inventories, morphological rules, parse grammars — because there wasn't enough data or compute to discover those regularities from scratch. This is the classic story, immortalized in the (only half-joking) line that every time you fire a linguist, model performance goes up a point. As data and compute scale, this kind of prior becomes redundant: the model finds an equivalent, often better, representation on its own. Feature engineering depreciates because it was always just a stand-in for statistical power that hadn't arrived yet.

Priors that correct a misaligned objective. Loudness normalization isn't in this first category. Neither, really, is a design choice I made in a separate project: rather than letting a model learn microphone array geometry end-to-end, I feed it in explicitly as a known, precise input, because the physical positions are already specified by the hardware manufacturer. There's no reason to make the model rediscover something we already know exactly. Both cases aren't "we don't have enough data to learn this," they're "the thing we actually want isn't what the loss function is measuring, so let's fix that directly."

The important claim here: this second category doesn't obviously shrink as models get bigger. If anything, more capacity makes a misaligned objective more dangerous, not less. A bigger model is simply better at finding and exploiting whatever shortcut the loss allows. Scale can replace "what features should I extract," but it can't by itself replace "what should the model actually be optimizing for." That's a judgment call, and it stays a judgment call regardless of parameter count.

## The fawn's priors are why it's capped

There's a comparison worth sitting with here: a fawn can walk within an hour of being born; a human infant can't do much of anything for months. And yet the fawn never amounts to much cognitively, while the human, despite the slow start, ends up with far greater general intelligence. If precocial development, nearly the whole behavioral repertoire pre-loaded genetically, were straightforwardly an advantage, the fawn should be ahead on both counts, not just the first one.

It isn't, and I think the reason is instructive. Baking a prior in at birth buys immediate competence, but it buys that competence by committing early to a fixed solution. The fawn's genome has essentially already decided how it will stand and run, and there isn't much slack left over for anything else. The human infant starts with almost nothing usable, but what it has instead is more general underlying structure and far greater raw capacity, unconstrained by an early commitment to any particular task. It takes longer to bootstrap, but it isn't capped the way the fawn is, the ceiling comes from the architecture, not from how much task-specific knowledge got hard-coded up front.

That's a real tension with the loudness-normalization story, not just a nice parallel to it, and it's worth naming directly. The two examples are pulling on different mechanisms. Hard-coding array geometry or normalizing loudness isn't committing the model to a fixed behavioral policy the way instinct commits the fawn — it's removing a confound from the loss surface so a still-general architecture can find better structure on its own. The fawn's priors are the answer, frozen in place. Loudness normalization just clears an obstacle out of the way of an answer the model still has to find itself. So the fawn comparison is a real caution against one particular way of using priors, baking in the final answer instead of general capacity, without being an argument against priors that merely fix a broken objective.

## Where this leaves "auto-research"

This is probably also why the current wave of autonomous research agents can produce competent output but rarely interesting output, while the genuinely interesting stuff, the "vibe maths" style of doing mathematics in tight back-and-forth with a model, is still showing up almost exclusively at the human-model interaction layer. It's not that the models lack raw capability. It's that "which question is worth asking" and "what should the objective actually reward" are exactly the second category of prior described above, objective-alignment judgment calls that scale doesn't automatically resolve, because they aren't a statistical-strength problem in the first place.

I don't think this means human bias is safe forever, in some romantic sense. I think it means the level at which human judgment matters keeps getting pushed upward. Feature engineering got automated; the judgment moved to preprocessing and objective design. If objective design itself eventually gets absorbed, if some outer loop learns to evaluate and select research directions the way we currently hand-pick a normalization step, the judgment doesn't disappear, it just moves up another level of abstraction.

So: what's our experience worth? Probably not much at the level of "which feature to extract." Still quite a lot at the level of "what should this thing actually be optimizing for", and that level has a way of surviving every round of the bitter lesson by relocating just above wherever the frontier currently sits.