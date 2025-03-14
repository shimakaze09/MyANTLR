/* Copyright (c) 2012-2017 The ANTLR Project. All rights reserved.
 * Use of this file is governed by the BSD 3-clause license that
 * can be found in the LICENSE.txt file in the project root.
 */

//
//  main.cpp
//  antlr4-cpp-demo
//
//  Created by Mike Lischke on 13.03.16.
//

#include <UANTLR/ParserCpp14/CPP14BaseVisitor.h>
#include <UANTLR/ParserCpp14/CPP14Lexer.h>
#include <UANTLR/ParserCpp14/CPP14Parser.h>
#include <Windows.h>
#include <antlr4-runtime.h>

#include <iostream>

#pragma execution_character_set("utf-8")

using namespace My;
using namespace antlr4;

int main(int argc, const char* argv[]) {
  ANTLRInputStream input(R"(
 namespace A::B {
   struct [[meta("hello world")]] Cmpt{
   };
 }
 )");
  CPP14Lexer lexer(&input);
  CommonTokenStream tokens(&lexer);

  CPP14BaseVisitor visitor;

  CPP14Parser parser(&tokens);
  tree::ParseTree* tree = parser.translationunit();
  tree->accept(&visitor);
  std::wstring s = antlrcpp::s2ws(tree->toStringTree(&parser)) + L"\n";

  // OutputDebugString(s.data()); // Only works properly since VS 2015.
  std::wcout << "Parse Tree: " << s
             << std::endl;  // Unicode output in the console is very limited.

  return 0;
}
