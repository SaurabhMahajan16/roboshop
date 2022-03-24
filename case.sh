#! /usr/bin/bash

x="abc"
case $x in
  abc) echo "x=abc"
    ;;
  xyz)
    echo "x=xyz"
    ;;
  *)
    echo "x is neither abc nor xyz"
    ;;
  esac

#case only does string comparisons
#if none of the comparison matches like else in elif then use *
#after in use space and then string to matched ) and after you give commands and then enter and use double semicolon
#ending the case by using esac and indentation of esac should not match with ;;