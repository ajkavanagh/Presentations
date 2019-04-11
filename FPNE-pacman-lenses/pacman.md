% Using Lenses to implement a Text based Pacman Game
% Alex Kavanagh
% 2019-04-09

# Introduction

::: incremental

- Why Haskell?
- Why Pac-man?
- Why Lenses?

:::

::: notes

- Why haskell?  Because I've been interested in learning it for a long, long, time.  Writing a Game seemed like an interesting thing to do.  Also, it was one of the topics for a previous FPNE!
- Why Pacman? See above!
- I'd been interested in then, and didn't really understand them.  Thus, they were a perfect learning opportunity.

:::

# What are we covering?

::: incremental

- Pac-man demo
- What are Lenses?
- Examples of their use
- Digging a bit deeper
- An operator for every ocasion
- (if there's time) The beginnings of how they work.

:::

# Pac-man Demo

(switch to another window ...) - ref: [2]

# What are Lenses?

::: incremental

- "Lenses are composable functional references" [1]
- They allow you to access and modify data potentially very deep within a structure.
- They "sort of" allow object orientated access!

:::

# view (^.)

Accessing structures:

```haskell
view _1 ("Hello",1)
"Hello"

("hello", 3) ^. _2
3
```

# Composing View

Digging deeper:

```haskell

-- Just the prelude (.) operator
(.) :: Lens' a b -> Lens' b c -> Lens' a c

view (_2._1) ("Hello",("There","I was"))
"There"

-- and

("Hello",("There","I go")) ^. (_2._2)
"I go"
```


# set (.~)

```haskell
set _1 "Goodbye" ("Hello","You")
("Goodbye","You")

-- and

("Hello","You") & _1 .~ "Goodbye"
("Goodbye","You")

-- and also

("Hello","there") & _1 .~ 10
                  & _2 .~ 4
(10,4)
```

# Quickly exploring the component parts

```haskell
   view       _1     ("Hello",1)
-- <operator> <lens> <structure>

   ("Hello",1)   ^.        _1
-- <structure> <operator> <lens>

   set        _1     "Goodbye" (1,2)
-- <operator> <lens> <item>    <structure>

   (1,2)            &         _1      .~        3
-- <structure> <flipped ($)> <lens> <operator> <item>
```

# Examples from Pac-man

Making a Lens

```haskell
data Game = Game
  { _pacman          :: PacmanData
  , _ghosts          :: [GhostData]
  , _ghostsMode       :: GhostsMode
  , _ghostsModes      :: [GhostsMode]
  , _maze            :: Maze
  , _mazeHeight      :: Int
  , _mazeWidth       :: Int
  -- etc
  } deriving (Show)

makeLenses ''Game
```

---

```haskell
data GhostData = GhostData
  { _ghostAt         :: Coord
  , _ghostDir        :: Direction
  , _ghostState      :: GhostState
  , _ghostName       :: GhostPersonality
  , _ghostTick       :: Int
  , _ghostPillCount  :: Int
  , _ghostRandStdGen :: StdGen
  } deriving (Show)

makeLenses ''GhostData
```

---

```haskell
data PacmanData = PacmanData
  { _pacAt        :: Coord
  , _pacDir       :: Direction
  , _pacNextDir   :: Direction
  , _pacDead      :: Bool
  , _pacTick      :: Int
  , _pacAnimate   :: Int
  } deriving (Eq, Show)

makeLenses ''PacmanData
```

# Using those lenses

```haskell
-- | whilstDyingAction -- keep the display updated for each animate tick
-- whilst the pacman is dying.  After a timer is expired (pacAnimate reaches
-- some value), then reset the game state for the next life.
whilstDyingAction :: Game -> DrawList Game
whilstDyingAction g
```

---

```haskell
  where
      _t = (g ^. pacman . pacAnimate) + 1
      remainingLives = (g ^. livesLeft) - 1
      (ghostsSeed, newStdGen) = random $ g ^. randStdGen
```

---

```haskell
whilstDyingAction :: Game -> DrawList Game
whilstDyingAction g
  -- not dead yet; so keep animating
  | _t < dyingComplete = do
      addDrawListItem $ DrawGridAt $ g ^. pacman . pacAt
      return $ g & (pacman . pacAnimate) %~ succ
                 & (pacman . pacTick) .~ choosePacTick g EatenNothing
```

---

```haskell
  -- Game over -- the game is done, so just leave it animating the ghosts
  | remainingLives == 0 = do
      addDrawListItem DrawEverything
      return $ g & gameState .~ GameOver gameOverFrames
```

---

```haskell
  -- we've lost a life, so reset pacman, the ghosts, and enable the global
  -- pill count to get ghosts out of the house
  | otherwise = do
      addDrawListItem DrawEverything
      return $ g & livesLeft .~ remainingLives
                 & pacman .~ resetPacman             -- tell pacman where to go
                 & ghosts .~ resetGhosts ghostsSeed  -- put ghosts back in the house
                 & framesSincePill .~ 0              -- reset global frames since pill
                 & globalPillCount ?~ 0              -- Set to Just 0, to activate global counter
                 & randStdGen .~ newStdGen
```

# Operators - 1

- Data.Lens.* and Lens.Micro.* has an operator for every ocassion
- e.g. (^..) -- infix version of `toListof`

```haskell
    let hws = g ^.. (ghosts . each . ghostAt)
```

- e.g. (?~) -- set something to `Just <value>`


```haskell
    g & globalPillCount ?~ 0
```

# Operators - 2

::: incremental

- view, set, map operators
- maths, including fractional
- `MonadState` operators
- Folds and Tranversals

:::

# Digging even deeper ...

Types of Setter, Getter and the laws

# References

- [1] - https://github.com/ekmett/lens/wiki/Overview
- [2] - TUI Pac-man in Haskell: https://github.com/ajkavanagh/pacman
