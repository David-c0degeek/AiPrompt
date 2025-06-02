# 🧠 AI Prompt Engineering Toolkit

A collection of modular, reusable AI prompts designed for technical collaboration, code review, and intellectual sparring. Build custom prompts on-demand with an interactive PowerShell script.

## 🎯 Philosophy

Stop getting bland agreement from AI assistants. This toolkit transforms AI into a **constructive intellectual sparring partner** that challenges your thinking, tests assumptions, and helps you build better solutions.

## 📁 What's Inside

| File | Purpose |
|------|---------|
| **`prompt_builder_script.ps1`** | Interactive PowerShell script to build custom prompts |
| **`modular_ai_prompts.md`** | Complete collection of modular prompt components |
| **`FullPrompt.md`** | Original monolithic prompt (now superseded by modular approach) |

## 🚀 Quick Start

### Option 1: Use the Script (Recommended)
1. **Download and run the PowerShell script:**
   ```powershell
   # Download the script
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/David-c0degeek/AiPrompt/main/prompt_builder_script.ps1" -OutFile "prompt_builder.ps1"
   
   # Run it
   .\prompt_builder.ps1
   ```

2. **Answer the questions** to build your custom prompt
3. **Copy the result** (automatically copied to clipboard) and paste into your AI conversation

### Option 2: Manual Assembly
Browse `modular_ai_prompts.md` and copy-paste the components you need.

## 🧩 Available Prompt Modes

### Core Modes
- **🔍 Challenge Mode** - Critical analysis, assumption testing, bias detection
- **🔧 Refactor Mode** - Safe code refactoring with behavior preservation
- **💡 Brainstorm Mode** - Generative thinking without immediate criticism
- **📚 Research Mode** - Source citation and confidence levels

### Context Add-ons
- **⚙️ C# Development** - SOLID principles, testing standards, .NET best practices
- **🔒 Security Awareness** - Threat modeling, input validation, secret protection
- **📖 Documentation Standards** - Clear writing, examples, consistent formatting
- **🚨 Red Flags Alert** - Code safety warnings and mutation detection

## 💡 Common Use Cases

### Code Review
```
Base Prompt + Challenge Mode + C# Context + Security Context
```
→ Rigorous code analysis with security considerations

### Safe Refactoring
```
Base Prompt + Refactor Mode + C# Context + Red Flags
```
→ Step-by-step refactoring with safety checks

### Architecture Exploration
```
Base Prompt + Brainstorm Mode + Challenge Mode + C# Context
```
→ Creative exploration followed by critical evaluation

### Technical Research
```
Base Prompt + Challenge Mode + Research Context
```
→ Thorough analysis with proper source citation

## 🛠️ Script Features

- **🎯 Smart Suggestions** - Shows what's already included to prevent duplication
- **🔍 Transparency** - Displays selected components at each step
- **📋 Auto-Copy** - Copies final prompt to clipboard automatically
- **🚫 Duplicate Prevention** - Won't offer the same component twice
- **💬 Contextual Help** - Shows what each component adds

## 📋 Prerequisites

- **Windows PowerShell** or **PowerShell Core**
- **Execution Policy** set to allow local scripts:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  ```

## 🎭 Prompt Philosophy

### The "Intellectual Sparring Partner" Approach

Traditional AI prompting often produces agreeable but shallow responses. This toolkit implements a different philosophy:

1. **Challenge First** - Test assumptions before building solutions
2. **Precision Over Politeness** - Direct feedback beats diplomatic non-answers
3. **Context-Aware** - Different tasks need different thinking modes
4. **Safety-First** - Especially for code changes, understand before acting

### When to Use Each Mode

| Task | Recommended Mode | Why |
|------|------------------|-----|
| Reviewing architecture decisions | Challenge + C# | Test assumptions, spot weak points |
| Refactoring legacy code | Refactor + Red Flags | Preserve behavior, catch side effects |
| Exploring new approaches | Brainstorm + Challenge | Generate ideas, then evaluate |
| Writing technical docs | Documentation + Research | Clear writing with proper citations |

## 🔧 Customization

### Adding New Components

1. **Edit the script** - Add your component to the variables section
2. **Update the menus** - Add options in the relevant functions
3. **Test thoroughly** - Ensure no syntax errors

### Project-Specific Adaptations

The script prompts for project context like:
- Architecture patterns (Clean Architecture, DDD, etc.)
- Key libraries (EF Core, MediatR, etc.)
- Team conventions and anti-patterns

## 📈 Evolution from Monolithic to Modular

This toolkit evolved from a single comprehensive prompt (`FullPrompt.md`) to a modular system because:

- **Cognitive Overhead** - One massive prompt was hard to parse
- **Context Mismatch** - Not every instruction applied to every conversation
- **Maintenance Burden** - Changes required editing the entire prompt
- **Flexibility** - Different tasks need different combinations

The modular approach lets you build exactly what you need, when you need it.

## 🤝 Contributing

Found a useful prompt pattern? Spotted a bug in the script? Contributions welcome!

1. **Fork the repo**
2. **Make your changes**
3. **Test thoroughly** (especially PowerShell syntax)
4. **Submit a pull request**

## 📄 License

MIT License - Use these prompts however they help you build better software.

## 🎯 Pro Tips

1. **Start Small** - Begin with base prompt + one mode, add complexity as needed
2. **Save Combinations** - Keep notes on which combinations work best for your common tasks
3. **Iterate** - AI conversations improve when you refine prompts based on results
4. **Share Context** - The more specific your project context, the better the AI's responses

---

**Happy prompting!** 🚀
