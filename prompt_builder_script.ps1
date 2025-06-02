# AI Prompt Builder Script v2
# Creates custom AI prompts by combining modular components

# Define prompt components
$BasePrompt = @"
Act as my intellectual collaborator. Your job is to help me think better, not just agree with me.

When working together:
- Ask clarifying questions when something is ambiguous
- Point out assumptions I might be making
- Suggest alternatives when you see them
- Be direct about problems or weaknesses you spot
- Prioritize correctness and clarity over politeness

If you're ever unsure about the right level of challenge or support for a task, just ask.
"@

$ChallengeMode = @"

Switch to critical analysis mode. For my next statement or idea:

1. **Test assumptions** - What am I taking for granted that might not be true?
2. **Find weak points** - Where could this reasoning break down?
3. **Spot bias** - Am I showing confirmation bias or motivated reasoning?
4. **Steel-man counter arguments** - What would a well-informed skeptic say?
5. **Suggest alternatives** - How else could this be framed or approached?

Be rigorous but constructive. If something is solid, say so and why.
"@

$RefactorMode = @"

Entering refactoring mode. Before making ANY code changes:

**Step 1: Understand Completely**
- Analyze the current behavior line by line
- Identify what values are captured and why
- Look for mutations, side effects, and ordering dependencies
- Flag any property access that might have side effects

**Step 2: Ask Before Acting**
- "Does [method] mutate the object or have side effects?"
- "Are there invariants I need to preserve?"
- "What exactly do you want changed and what should stay the same?"

**Step 3: Minimal First Pass**
- Only address your specific request initially
- Preserve exact behavior - same order, same mutations, same side effects
- Document assumptions: "// Assuming: user.Email is a pure property getter with no side effects"
- Add warnings: "// WARNING: If UpdateProfile() also sends notifications, this refactoring is incorrect"

**Step 4: Get Confirmation**
- First iteration = same behavior, minimal change
- After approval, suggest cleanups/improvements separately

**Red flag principle**: If I don't fully understand what the code does, I'll ask rather than guess.

**Motto**: Correctness first, elegance second. Never refactor what you don't fully understand.
"@

$BrainstormMode = @"

Switching to generative brainstorming mode:

- Focus on generating ideas rather than critiquing them
- Build on concepts rather than immediately testing them
- Explore possibilities without immediate constraint checking
- Use "yes, and..." thinking to expand directions
- Save critical analysis for after we've explored the space

I'll still ask clarifying questions, but I'll lean toward creativity and exploration over immediate validation.
"@

$CSharpContext = @"

**Development Environment:**
- Language: C# (.NET)
- Assume Windows PowerShell/WSL for CLI commands
- Follow SOLID, DRY, YAGNI, CLEAN, KISS principles (but DRY not at the cost of clarity)
- Prefer immutable types when possible
- Keep files under 300 lines (except test files, generated code)
- Split large classes by domain responsibility
- Avoid "god objects" or generic utility dumps
- Add unit tests for new logic and edge cases
- Make tests fast, focused, and non-flaky

**Environment Awareness:**
- Use config-based approaches for environment-specific behavior
- Never hardcode prod/test/dev identifiers
- Never modify .env files, credentials, or secrets without explicit instruction

**Change Management:**
- Only modify what you specifically ask for
- Flag unrelated issues but don't fix without permission
- Stick to existing patterns unless approved otherwise

**Code Safety:**
- Be cautious with property access - don't assume getters are safe
- When mutating objects: make it obvious and document it
- Respect side-effect boundaries
"@

$ResearchContext = @"

**Research Mode:**
- Cite sources when making factual claims
- Distinguish between established knowledge and speculation
- Flag when information might be outdated
- Suggest additional research directions
- Be explicit about confidence levels in conclusions
"@

$RedFlags = @"

**Always alert me immediately if you see:**
- ❗ Values being saved before method calls (mutation signal)
- ❗ Side-effectful property access (non-pure getters)
- ❗ Hidden control flow or mutation across method calls
- ❗ Refactorings that risk changing semantics
- ❗ Patterns that contradict established project conventions
- ❗ Potential perf bottlenecks, memory leaks, or unbounded recursion
- ❗ Hardcoded secrets, config paths, or environment identifiers
- ❗ Anything that could affect security posture

Raise the concern and wait for confirmation before addressing it.
"@

$DocumentationContext = @"

**Documentation Standards:**
- Write clear, scannable documentation
- Include concrete examples for complex concepts
- Document edge cases and gotchas
- Keep README files current and actionable
- Use consistent formatting and structure
"@

$SecurityContext = @"

**Security Awareness:**
- Never expose secrets, API keys, or credentials
- Validate all inputs and sanitize outputs
- Follow principle of least privilege
- Consider attack vectors and threat models
- Document security assumptions and requirements
"@

# Component tracking
$SelectedComponents = @()

function Show-Menu {
    Write-Host "`n=== AI Prompt Builder v2 ===" -ForegroundColor Cyan
    Write-Host "Let's build your custom prompt step by step.`n" -ForegroundColor Yellow
}

function Show-CurrentSelection {
    if ($SelectedComponents.Count -gt 0) {
        Write-Host "`nCurrent components selected:" -ForegroundColor Yellow
        foreach ($component in $SelectedComponents) {
            Write-Host "  ✓ $component" -ForegroundColor Green
        }
        Write-Host ""
    }
}

function Add-Component {
    param($ComponentName)
    if ($ComponentName -notin $SelectedComponents) {
        $SelectedComponents += $ComponentName
    }
}

function Get-WorkType {
    Write-Host "What type of work are you doing?" -ForegroundColor Green
    Write-Host "1. Code review/architecture critique (includes Challenge Mode)"
    Write-Host "2. Refactoring existing code (includes Refactor Protocol + Red Flags)"
    Write-Host "3. Brainstorming/exploring ideas (includes Brainstorm Mode)"
    Write-Host "4. Research and analysis (includes Challenge + Research modes)"
    Write-Host "5. Documentation/writing (includes Documentation standards)"
    Write-Host "6. Security review (includes Challenge + Security contexts)"
    Write-Host "7. General discussion (just base prompt)"
    Write-Host "8. Custom combination"
    
    do {
        $choice = Read-Host "`nEnter choice (1-8)"
    } while ($choice -notmatch '^[1-8]$')
    
    return [int]$choice
}

function Get-TechStack {
    Show-CurrentSelection
    Write-Host "What's your tech stack?" -ForegroundColor Green
    Write-Host "1. C# / .NET (adds C# development context)"
    Write-Host "2. Other/No specific tech context"
    
    do {
        $choice = Read-Host "`nEnter choice (1-2)"
    } while ($choice -notmatch '^[1-2]$')
    
    if ($choice -eq 1) {
        Add-Component "C# Development Context"
    }
    
    return [int]$choice
}

function Get-AdditionalContexts {
    param($WorkType)
    
    Show-CurrentSelection
    Write-Host "Additional contexts (select any that apply):" -ForegroundColor Green
    
    # Show what is already covered by current work type
    Write-Host "`nAlready included based on your work type:" -ForegroundColor Gray
    switch ($WorkType) {
        1 { Write-Host "  • Critical analysis and assumption testing" -ForegroundColor DarkGray }
        2 { 
            Write-Host "  • Step-by-step refactoring protocol" -ForegroundColor DarkGray
            Write-Host "  • Code safety red flags and mutation alerts" -ForegroundColor DarkGray
        }
        3 { Write-Host "  • Generative brainstorming and idea exploration" -ForegroundColor DarkGray }
        4 { 
            Write-Host "  • Critical analysis and assumption testing" -ForegroundColor DarkGray
            Write-Host "  • Source citation and research standards" -ForegroundColor DarkGray
        }
        5 { Write-Host "  • Documentation standards and formatting" -ForegroundColor DarkGray }
        6 { 
            Write-Host "  • Critical analysis and assumption testing" -ForegroundColor DarkGray
            Write-Host "  • Security awareness and threat considerations" -ForegroundColor DarkGray
        }
    }
    Write-Host ""
    
    $availableContexts = @()
    
    # Research context is useful for many work types
    if ($WorkType -notin @(4, 6)) {
        $availableContexts += @{
            Name="Research"
            Description="Research standards (citing sources, confidence levels)"
            Details="Adds: Source citation requirements, speculation vs. fact distinction, confidence levels"
        }
    }
    
    # Documentation context
    if ($WorkType -ne 5) {
        $availableContexts += @{
            Name="Documentation"
            Description="Documentation standards"
            Details="Adds: Clear writing, examples, edge cases, consistent formatting"
        }
    }
    
    # Security context
    if ($WorkType -ne 6) {
        $availableContexts += @{
            Name="Security"
            Description="Security awareness"
            Details="Adds: Secret protection, input validation, threat modeling, least privilege"
        }
    }
    
    # Red flags (if not already included)
    if ($WorkType -ne 2) {
        $availableContexts += @{
            Name="RedFlags"
            Description="Code safety red flags alert system"
            Details="Adds: Mutation detection, side-effect warnings, performance alerts"
        }
    }
    
    if ($availableContexts.Count -eq 0) {
        Write-Host "No additional contexts available for this work type." -ForegroundColor Gray
        return @()
    }
    
    $selectedAdditional = @()
    
    for ($i = 0; $i -lt $availableContexts.Count; $i++) {
        $context = $availableContexts[$i]
        Write-Host "$($i + 1). $($context.Description)" -ForegroundColor White
        Write-Host "     $($context.Details)" -ForegroundColor DarkGray
    }
    Write-Host "0. None/Continue"
    
    do {
        $choice = Read-Host "`nSelect additional context (0 to continue, or comma-separated numbers like 1,3)"
        
        if ($choice -eq "0" -or $choice -eq "") {
            break
        }
        
        $choices = $choice -split "," | ForEach-Object { $_.Trim() }
        foreach ($c in $choices) {
            if ($c -match '^\d+$' -and [int]$c -le $availableContexts.Count -and [int]$c -gt 0) {
                $selectedContext = $availableContexts[[int]$c - 1]
                $selectedAdditional += $selectedContext.Name
                Add-Component $selectedContext.Description
            }
        }
        break
    } while ($true)
    
    return $selectedAdditional
}

function Get-ProjectContext {
    param($TechStack)
    
    Show-CurrentSelection
    Write-Host "Do you want to add project-specific context?" -ForegroundColor Green
    
    # Show what is already covered
    if ($TechStack -eq 1) {
        Write-Host "`nAlready covered by C# context:" -ForegroundColor Gray
        Write-Host "  • SOLID, DRY, YAGNI, CLEAN, KISS principles" -ForegroundColor DarkGray
        Write-Host "  • Immutable types preference" -ForegroundColor DarkGray
        Write-Host "  • File size limits (300 lines except tests/generated)" -ForegroundColor DarkGray
        Write-Host "  • Unit testing expectations" -ForegroundColor DarkGray
        Write-Host "  • Environment-aware config practices" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    $addContext = Read-Host "y/N"
    
    if ($addContext -match '^[yY]') {
        Write-Host "`nEnter additional project details (avoid duplicating what is shown above):" -ForegroundColor Yellow
        $projectLines = @()
        
        $framework = Read-Host "Framework/Architecture (e.g., Clean Architecture, MVC, Hexagonal)"
        if ($framework) { $projectLines += "- Architecture: $framework" }
        
        $libraries = Read-Host "Key Libraries (e.g., EF Core, MediatR, Polly, AutoMapper)"
        if ($libraries) { $projectLines += "- Key Libraries: $libraries" }
        
        $database = Read-Host "Database (e.g., SQL Server, PostgreSQL, MongoDB)"
        if ($database) { $projectLines += "- Database: $database" }
        
        $patterns = Read-Host "Project-specific patterns/conventions (beyond standard SOLID/DRY)"
        if ($patterns) { $projectLines += "- Special Patterns: $patterns" }
        
        $antipatterns = Read-Host "Project-specific anti-patterns to avoid"
        if ($antipatterns) { $projectLines += "- Anti-patterns: $antipatterns" }
        
        $tooling = Read-Host "Specific tooling/CI requirements (if relevant)"
        if ($tooling) { $projectLines += "- Tooling: $tooling" }
        
        if ($projectLines.Count -gt 0) {
            Add-Component "Project-Specific Context"
            return "`n**Current Project Context:**`n" + ($projectLines -join "`n")
        }
    }
    
    return ""
}

function Get-UserQuestion {
    Show-CurrentSelection
    Write-Host "What do you want to ask or discuss?" -ForegroundColor Green
    Write-Host "(This will be added to the end of your prompt)" -ForegroundColor Gray
    $question = Read-Host "`nYour question/topic"
    
    if ($question.Trim()) {
        return "`n---`n`n$question"
    }
    return ""
}

function Build-CustomPrompt {
    Show-CurrentSelection
    Write-Host "Custom combination - select components:" -ForegroundColor Green
    
    $components = @()
    
    # Base prompt is always included
    $components += $BasePrompt
    Add-Component "Base Prompt (always included)"
    
    Write-Host "`nInclude Challenge Mode? (y/N)"
    Write-Host "  Adds: Assumption testing, weak point analysis, bias detection" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $ChallengeMode
        Add-Component "Challenge Mode"
    }
    
    Write-Host "`nInclude Refactor Mode? (y/N)"
    Write-Host "  Adds: Step-by-step refactoring protocol, behavior preservation" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $RefactorMode
        Add-Component "Refactor Mode"
    }
    
    Write-Host "`nInclude Brainstorm Mode? (y/N)"
    Write-Host "  Adds: Generative thinking, yes and approach, delayed criticism" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $BrainstormMode
        Add-Component "Brainstorm Mode"
    }
    
    Write-Host "`nInclude C# Context? (y/N)"
    Write-Host "  Adds: SOLID/DRY/YAGNI principles, immutable types, testing standards" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $CSharpContext
        Add-Component "C# Development Context"
    }
    
    Write-Host "`nInclude Research Context? (y/N)"
    Write-Host "  Adds: Source citation, confidence levels, speculation vs. facts" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $ResearchContext
        Add-Component "Research Context"
    }
    
    Write-Host "`nInclude Documentation Context? (y/N)"
    Write-Host "  Adds: Clear writing standards, examples, consistent formatting" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $DocumentationContext
        Add-Component "Documentation Context"
    }
    
    Write-Host "`nInclude Security Context? (y/N)"
    Write-Host "  Adds: Secret protection, input validation, threat modeling" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $SecurityContext
        Add-Component "Security Context"
    }
    
    Write-Host "`nInclude Red Flags Alert? (y/N)"
    Write-Host "  Adds: Mutation detection, side-effect warnings, performance alerts" -ForegroundColor DarkGray
    if ((Read-Host) -match '^[yY]') { 
        $components += $RedFlags
        Add-Component "Red Flags Alert"
    }
    
    return $components -join ""
}

# Main script execution
Show-Menu

$workType = Get-WorkType
$finalPrompt = ""
$techStack = 2  # Default to "other"

# Build base prompt based on work type
switch ($workType) {
    1 { # Code review
        $finalPrompt = $BasePrompt + $ChallengeMode
        Add-Component "Base Prompt"
        Add-Component "Challenge Mode"
        $techStack = Get-TechStack
        if ($techStack -eq 1) { $finalPrompt += $CSharpContext }
    }
    2 { # Refactoring
        $finalPrompt = $BasePrompt + $RefactorMode + $RedFlags
        Add-Component "Base Prompt"
        Add-Component "Refactor Mode"
        Add-Component "Red Flags Alert"
        $techStack = Get-TechStack
        if ($techStack -eq 1) { $finalPrompt += $CSharpContext }
    }
    3 { # Brainstorming
        $finalPrompt = $BasePrompt + $BrainstormMode
        Add-Component "Base Prompt"
        Add-Component "Brainstorm Mode"
        $techStack = Get-TechStack
        if ($techStack -eq 1) { $finalPrompt += $CSharpContext }
    }
    4 { # Research
        $finalPrompt = $BasePrompt + $ChallengeMode + $ResearchContext
        Add-Component "Base Prompt"
        Add-Component "Challenge Mode"
        Add-Component "Research Context"
    }
    5 { # Documentation
        $finalPrompt = $BasePrompt + $DocumentationContext
        Add-Component "Base Prompt"
        Add-Component "Documentation Context"
        $techStack = Get-TechStack
        if ($techStack -eq 1) { $finalPrompt += $CSharpContext }
    }
    6 { # Security
        $finalPrompt = $BasePrompt + $ChallengeMode + $SecurityContext
        Add-Component "Base Prompt"
        Add-Component "Challenge Mode"
        Add-Component "Security Context"
        $techStack = Get-TechStack
        if ($techStack -eq 1) { $finalPrompt += $CSharpContext }
    }
    7 { # General
        $finalPrompt = $BasePrompt
        Add-Component "Base Prompt"
    }
    8 { # Custom
        $finalPrompt = Build-CustomPrompt
    }
}

# Get additional contexts (only show options not already included)
if ($workType -ne 8) {  # Skip for custom (already handled)
    $additionalContexts = Get-AdditionalContexts $workType
    foreach ($context in $additionalContexts) {
        switch ($context) {
            "Research" { $finalPrompt += $ResearchContext }
            "Documentation" { $finalPrompt += $DocumentationContext }
            "Security" { $finalPrompt += $SecurityContext }
            "RedFlags" { $finalPrompt += $RedFlags }
        }
    }
}

# Add project context if applicable (tech-related work types)
if ($workType -in @(1,2,3,5,6) -and $techStack -eq 1) {
    $projectContext = Get-ProjectContext $techStack
    $finalPrompt += $projectContext
}

# Add user's question
$userQuestion = Get-UserQuestion
$finalPrompt += $userQuestion

# Show final summary
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "FINAL PROMPT SUMMARY:" -ForegroundColor Yellow
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nComponents included:" -ForegroundColor Green
foreach ($component in $SelectedComponents) {
    Write-Host "  ✓ $component" -ForegroundColor Green
}

Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "YOUR CUSTOM PROMPT:" -ForegroundColor Yellow
Write-Host "="*60 -ForegroundColor Cyan
Write-Host $finalPrompt

# Copy to clipboard if available
try {
    $finalPrompt | Set-Clipboard
    Write-Host "`n✅ Prompt copied to clipboard!" -ForegroundColor Green
} catch {
    Write-Host "`n📋 Copy the prompt above manually" -ForegroundColor Yellow
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")