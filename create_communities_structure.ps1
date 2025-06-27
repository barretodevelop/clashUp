# Script para criar estrutura de pastas e arquivos do sistema de Comunidades
# Projeto: ClashUp - Sistema de Comunidades

Write-Host "Iniciando criacao da estrutura do sistema de Comunidades..." -ForegroundColor Green

# Definir diretorio base do projeto
$baseDir = Get-Location
Write-Host "Diretorio base: $baseDir" -ForegroundColor Cyan

# Criar estrutura de diretorios
Write-Host "Criando estrutura de diretorios..." -ForegroundColor Yellow

$directories = @(
    "lib\features\communities",
    "lib\features\communities\models",
    "lib\features\communities\services", 
    "lib\features\communities\providers",
    "lib\features\communities\screens",
    "lib\features\communities\widgets",
    "lib\features\communities\utils",
    "lib\features\communities\constants"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $baseDir $dir
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "Criado: $dir" -ForegroundColor Cyan
    } else {
        Write-Host "Ja existe: $dir" -ForegroundColor Gray
    }
}

# Definir arquivos a serem criados
Write-Host "Criando arquivos base..." -ForegroundColor Yellow

$files = @{
    # MODELS (7 arquivos)
    "lib\features\communities\models\community_model.dart" = "// CommunityModel - Dados basicos da comunidade"
    "lib\features\communities\models\community_member_model.dart" = "// CommunityMemberModel - Relacionamento usuario-comunidade"
    "lib\features\communities\models\community_post_model.dart" = "// CommunityPostModel - Posts/topicos da comunidade"
    "lib\features\communities\models\community_comment_model.dart" = "// CommunityCommentModel - Comentarios nos posts"
    "lib\features\communities\models\community_event_model.dart" = "// CommunityEventModel - Eventos da comunidade"
    "lib\features\communities\models\community_badge_model.dart" = "// CommunityBadgeModel - Badges especiais"
    "lib\features\communities\models\community_stats_model.dart" = "// CommunityStatsModel - Estatisticas e metricas"
    
    # SERVICES (4 arquivos)
    "lib\features\communities\services\community_service.dart" = "// CommunityService - Operacoes CRUD no Firestore"
    "lib\features\communities\services\community_recommendation_service.dart" = "// CommunityRecommendationService - IA para recomendacoes"
    "lib\features\communities\services\community_notification_service.dart" = "// CommunityNotificationService - Notificacoes em tempo real"
    "lib\features\communities\services\community_moderation_service.dart" = "// CommunityModerationService - Sistema de moderacao"
    
    # PROVIDERS (6 arquivos)
    "lib\features\communities\providers\community_provider.dart" = "// CommunityProvider - Estado global das comunidades"
    "lib\features\communities\providers\community_list_provider.dart" = "// CommunityListProvider - Lista de comunidades do usuario"
    "lib\features\communities\providers\community_recommendations_provider.dart" = "// CommunityRecommendationsProvider - Recomendacoes personalizadas"
    "lib\features\communities\providers\community_posts_provider.dart" = "// CommunityPostsProvider - Posts de uma comunidade"
    "lib\features\communities\providers\community_members_provider.dart" = "// CommunityMembersProvider - Membros de uma comunidade"
    "lib\features\communities\providers\community_stats_provider.dart" = "// CommunityStatsProvider - Estatisticas e analytics"
    
    # SCREENS (8 arquivos)
    "lib\features\communities\screens\community_list_screen.dart" = "// CommunityListScreen - Lista das comunidades do usuario"
    "lib\features\communities\screens\community_detail_screen.dart" = "// CommunityDetailScreen - Detalhes de uma comunidade especifica"
    "lib\features\communities\screens\community_create_screen.dart" = "// CommunityCreateScreen - Criar nova comunidade"
    "lib\features\communities\screens\community_post_screen.dart" = "// CommunityPostScreen - Visualizar/criar posts"
    "lib\features\communities\screens\community_members_screen.dart" = "// CommunityMembersScreen - Lista de membros"
    "lib\features\communities\screens\community_search_screen.dart" = "// CommunitySearchScreen - Busca de comunidades"
    "lib\features\communities\screens\community_events_screen.dart" = "// CommunityEventsScreen - Eventos da comunidade"
    "lib\features\communities\screens\community_discovery_screen.dart" = "// CommunityDiscoveryScreen - Descobrir novas comunidades"
    
    # WIDGETS (10 arquivos)
    "lib\features\communities\widgets\community_card.dart" = "// CommunityCard - Card de comunidade na lista"
    "lib\features\communities\widgets\community_header.dart" = "// CommunityHeader - Header com info da comunidade"
    "lib\features\communities\widgets\community_post_card.dart" = "// CommunityPostCard - Card de post/topico"
    "lib\features\communities\widgets\community_member_tile.dart" = "// CommunityMemberTile - Tile de membro"
    "lib\features\communities\widgets\community_stats_widget.dart" = "// CommunityStatsWidget - Estatisticas visuais"
    "lib\features\communities\widgets\community_badge_widget.dart" = "// CommunityBadgeWidget - Badges e conquistas"
    "lib\features\communities\widgets\community_search_bar.dart" = "// CommunitySearchBar - Barra de busca customizada"
    "lib\features\communities\widgets\community_join_button.dart" = "// CommunityJoinButton - Botao de entrar/sair"
    "lib\features\communities\widgets\community_event_card.dart" = "// CommunityEventCard - Card de evento"
    "lib\features\communities\widgets\community_reaction_bar.dart" = "// CommunityReactionBar - Barra de reacoes"
    
    # UTILS E CONSTANTS (3 arquivos)
    "lib\features\communities\utils\community_utils.dart" = "// CommunityUtils - Utilitarios e helpers"
    "lib\features\communities\utils\community_validators.dart" = "// CommunityValidators - Validacoes de formularios"
    "lib\features\communities\constants\community_constants.dart" = "// CommunityConstants - Constantes do sistema"
}

# Criar arquivos com comentarios iniciais
$filesCreated = 0
foreach ($file in $files.GetEnumerator()) {
    $fullPath = Join-Path $baseDir $file.Key
    if (!(Test-Path $fullPath)) {
        $content = @"
$($file.Value)
// Arquivo criado automaticamente pelo script de estrutura
// Data: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
"@
        Set-Content -Path $fullPath -Value $content -Encoding UTF8
        Write-Host "Criado: $($file.Key)" -ForegroundColor Green
        $filesCreated++
    } else {
        Write-Host "Ja existe: $($file.Key)" -ForegroundColor Gray
    }
}

# Criar arquivo principal de exportacao
$exportFile = "lib\features\communities\communities.dart"
$exportPath = Join-Path $baseDir $exportFile

if (!(Test-Path $exportPath)) {
    $exportContent = @"
// communities.dart - Arquivo principal de exportacao do sistema de Comunidades
// Arquivo criado automaticamente pelo script de estrutura
// Data: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

// MODELS
export 'models/community_model.dart';
export 'models/community_member_model.dart';
export 'models/community_post_model.dart';
export 'models/community_comment_model.dart';
export 'models/community_event_model.dart';
export 'models/community_badge_model.dart';
export 'models/community_stats_model.dart';

// SERVICES
export 'services/community_service.dart';
export 'services/community_recommendation_service.dart';
export 'services/community_notification_service.dart';
export 'services/community_moderation_service.dart';

// PROVIDERS
export 'providers/community_provider.dart';
export 'providers/community_list_provider.dart';
export 'providers/community_recommendations_provider.dart';
export 'providers/community_posts_provider.dart';
export 'providers/community_members_provider.dart';
export 'providers/community_stats_provider.dart';

// SCREENS
export 'screens/community_list_screen.dart';
export 'screens/community_detail_screen.dart';
export 'screens/community_create_screen.dart';
export 'screens/community_post_screen.dart';
export 'screens/community_members_screen.dart';
export 'screens/community_search_screen.dart';
export 'screens/community_events_screen.dart';
export 'screens/community_discovery_screen.dart';

// WIDGETS
export 'widgets/community_card.dart';
export 'widgets/community_header.dart';
export 'widgets/community_post_card.dart';
export 'widgets/community_member_tile.dart';
export 'widgets/community_stats_widget.dart';
export 'widgets/community_badge_widget.dart';
export 'widgets/community_search_bar.dart';
export 'widgets/community_join_button.dart';
export 'widgets/community_event_card.dart';
export 'widgets/community_reaction_bar.dart';

// UTILS E CONSTANTS
export 'utils/community_utils.dart';
export 'utils/community_validators.dart';
export 'constants/community_constants.dart';
"@

    Set-Content -Path $exportPath -Value $exportContent -Encoding UTF8
    Write-Host "Criado: $exportFile" -ForegroundColor Green
    $filesCreated++
}

# Resumo final
Write-Host ""
Write-Host "Estrutura criada com sucesso!" -ForegroundColor Green
Write-Host "Total de arquivos criados: $filesCreated" -ForegroundColor Cyan
Write-Host "Total de diretorios: $($directories.Count)" -ForegroundColor Cyan

Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "1. Implementar CommunityModel" -ForegroundColor White
Write-Host "2. Atualizar UserModel com campos de comunidade" -ForegroundColor White  
Write-Host "3. Implementar CommunityService" -ForegroundColor White
Write-Host "4. Criar telas basicas" -ForegroundColor White
Write-Host "5. Integrar com navegacao existente" -ForegroundColor White

Write-Host ""
Write-Host "Estrutura do sistema de Comunidades criada com sucesso!" -ForegroundColor Green

# Verificar se todos os arquivos foram criados
Write-Host ""
Write-Host "Verificando estrutura criada..." -ForegroundColor Yellow
$allFiles = $files.Keys + $exportFile
$existingFiles = 0
foreach ($file in $allFiles) {
    $fullPath = Join-Path $baseDir $file
    if (Test-Path $fullPath) {
        $existingFiles++
    }
}

Write-Host "Arquivos verificados: $existingFiles de $($allFiles.Count)" -ForegroundColor Cyan

if ($existingFiles -eq $allFiles.Count) {
    Write-Host "Todas as estruturas foram criadas corretamente!" -ForegroundColor Green
} else {
    Write-Host "Alguns arquivos podem nao ter sido criados. Verifique manualmente." -ForegroundColor Yellow
}