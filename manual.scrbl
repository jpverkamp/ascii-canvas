#lang scribble/manual

@(require scribble/eval
          (for-label racket
                     images/flomap
                     racket/flonum))

@title{ascii-canvas: Code 437-based ASCII display for Racket}
@author{@author+email["John-Paul Verkamp" "me@jverkamp.com"]}

@code{ascii-canvas} simulates a code page 437 ASCII terminal display. It supports
all 256 characters of codepage 437, arbitrary foreground colors, arbitrary
background colors, and arbitrary terminal sizes.

This should be useful to roguelike developers.

THe API and code are strongly based on 
@hyperlink["https://github.com/trystan/AsciiPanel"]{Trystan's AsciiPanel for Java}.

@bold{Development} Development of this library is hosted by @hyperlink["http://github.com"]{GitHub} at the following project page:

@url{https://github.com/jpverkamp/asci-canvas/}

@section{Installation}

@commandline{raco pkg install github://github.com/jpverkamp/ascii-canvas/master}

@section{Functions}

@defclass[ascii-canvas% canvas% ()]{
  An extension of @code{canvas%} specifically designed to display ASCII
  characters.
  
  @defconstructor[([parent canvas%] 
                   [tileset-filename string? "cp437_16x16.png"]
                   [width-in-characters exact-nonnegative-integer? 80]
                   [height-in-characters exact-nonnegative-integer? 25])]{
    Create a new ASCII canvas.
  
    Size will be automatically determined by the tileset file and width
    and height of the canvas in characters.
  }
                                                                         
  @defmethod[(get-char-height) exact-nonnegative-integer?]{
    Get the height of a single character. Automatically derived from
    the @code{tileset-filename}.
  }
  
  @defmethod[(get-char-width) exact-nonnegative-integer?]{
    Get the width of a single character. Automatically derived from
    the @code{tileset-filename}.
  }
  
  @defmethod[(get-height-in-characters) exact-nonnegative-integer?]{
    Get the height of the @code{ascii-canvas} in characters.
  }
  
  @defmethod[(get-width-in-characters) exact-nonnegative-integer?]{
    Get the width of the @code{ascii-canvas} in characters.
  }
  
  @defmethod[(get-cursor-x) exact-nonnegative-integer?]{
    Get the x-coordinate of the cursor in tiles.
  }
  
  @defmethod[(set-cursor-x [x exact-nonnegative-integer?]) exact-nonnegative-integer?]{
    Set the x-coordinate of the cursor in tiles.
  }
  
  @defmethod[(get-cursor-y) exact-nonnegative-integer?]{
    Get the y-coordinate of the cursor in tiles.
  }
  
  @defmethod[(set-cursor-y [y exact-nonnegative-integer?]) exact-nonnegative-integer?]{
    Set the y-coordinate of the cursor in tiles.
  }
  
  @defmethod[(set-cursor-position [x exact-nonnegative-integer?]
                                  [y exact-nonnegative-integer?])
             exact-nonnegative-integer?]{
    Set the x- and y-coordinates of the cursor in tiles.
  }
                                        
  @defmethod[(get-default-background-color) color%]{
    Get the default background color used to print tiles with no background set.
  }
  
  @defmethod*[([(set-default-background-color [color string?]) void]
               [(set-default-background-color [r byte?] [g byte?] [b byte?]) void]
               [(set-default-background-color [r byte?] [g byte?] [b byte?] [a byte?]) void])]{
    Set the default background color either by name, by RGB, or by RGBA.
  }
                                                                                              
  @defmethod[(get-default-foreground-color) color%]{
    Get the default foreground color used to print tiles with no foreground set.
  }
  
  @defmethod*[([(set-default-foreground-color [color string?]) void]
               [(set-default-foreground-color [r byte?] [g byte?] [b byte?]) void]
               [(set-default-foreground-color [r byte?] [g byte?] [b byte?] [a byte?]) void])]{
    Set the default foreground color either by name, by RGB, or by RGBA.
  }
                                                                                              
  @defmethod[(clear [char char? #\space] 
                    [x exact-nonnegative-integer? 0] 
                    [y exact-nonnegative-integer? 0]
                    [width exact-nonnegative-integer? width-in-characters]
                    [height exact-nonnegative-integer? height-in-characters]
                    [foreground color% default-foreground-color]
                    [background color% default-background-color])
             void]{
    Clear the screen.
    
    If @code{char} is set, write that character to the specified region.
    
    If @code{x} and @code{y} are set, they define the top/left corner to clear.
    
    If @code{width} and @code{height} are set, they define the size of the
    region to clear.
    
    If @code{foreground} and @code{background} are set, they define the colors
    used for the character to clear with.
  }
                                                                  
  @defmethod[(write [char char?] 
                    [x exact-nonnegative-integer? 0] 
                    [y exact-nonnegative-integer? 0]
                    [foreground color% default-foreground-color]
                    [background color% default-background-color]) void]{
    Write a single @code{char} to the screen.
    
    If @code{x} and @code{y} are set, write the character there.
    
    If @code{foreground} and @code{background} are set, they define the colors
    used for the character.
  }
                                                                  
  @defmethod[(write-string [str string?] 
                           [x exact-nonnegative-integer? 0] 
                           [y exact-nonnegative-integer? 0]
                           [foreground color% default-foreground-color]
                           [background color% default-background-color]) void]{
    Write a string @code{char} to the screen.
    
    If @code{x} and @code{y} are set, start the character there.
    
    If @code{foreground} and @code{background} are set, they define the colors
    used for the string.
  }
                                                                              
  @defmethod[(write-center [str string?] 
                           [y exact-nonnegative-integer? 0]
                           [foreground color% default-foreground-color]
                           [background color% default-background-color]) void]{
    Write a string @code{char} to the screen.
    
    If @code{y} is set, write the string to that line (centered).
    
    If @code{foreground} and @code{background} are set, they define the colors
    used for the string.
  }
                                                                              
  @defmethod[(for-each-tile [x exact-nonnegative-integer? 0]
                            [y exact-nonnegative-integer? 0]
                            [width exact-nonnegative-integer? width-in-characters]
                            [height exact-nonnegative-integer? height-in-characters]
                            [f (-> exact-nonnegative-integer?
                                   exact-nonnegative-integer?
                                   char?
                                   color%
                                   color%
                                   (values char? color% color%))])
             void]{
    Apply a function to each tile in a region. @code{x}, @code{y}, 
    @code{width}, and @code{height} define the region, defaulting to
    the entire screen.
    
    @code{f} should take a coordinate, character, and foreground/background
    colors and return a new character and foreground/background.
  }            
}
   
@section{Examples}

See @hyperlink["https://github.com/jpverkamp/racket-roguelike/"]{GitHub: jpverkamp/racket-roguelike}
for an example game written using ASCII canvas.

@section{License}

This program is free software: you can redistribute it and/or modify it
under the terms of the 
@hyperlink["http://www.gnu.org/licenses/lgpl.html"]{GNU Lesser General
Public License} as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License and GNU Lesser General Public License for more
details.