//
//  SQLManagerStars.swift
//  BeeFun
//
//  Created by WengHengcong on 22/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import SQLite

class SQLStars: NSObject {

    static var retryCount: Int = 0

    /// 表格相关
    static let starTableName = "star_repos"
    internal static let starReposTable = Table(starTableName)

    // MARK: - 字段
    internal static let archive_url = Expression<String?>("archive_url")
    internal static let assignees_url = Expression<String?>("assignees_url")
    internal static let blobs_url = Expression<String?>("blobs_url")
    internal static let branches_url = Expression<String?>("branches_url")
    internal static let clone_url = Expression<String?>("clone_url")
    internal static let collaborators_url = Expression<String?>("collaborators_url")
    internal static let comments_url = Expression<String?>("comments_url")
    internal static let commits_url = Expression<String?>("commits_url")
    internal static let compare_url = Expression<String?>("compare_url")
    internal static let contents_url = Expression<String?>("contents_url")
    
    internal static let contributors_url = Expression<String?>("contributors_url")
    internal static let created_at = Expression<String?>("created_at")
    internal static let default_branch = Expression<String?>("default_branch")
    internal static let deployments_url = Expression<String?>("deployments_url")
    internal static let description = Expression<String?>("description")
    internal static let downloads_url = Expression<String?>("downloads_url")
    internal static let events_url = Expression<String?>("events_url")
    internal static let fork = Expression<Bool?>("fork")
    internal static let forks = Expression<Int?>("forks")
    internal static let forks_count = Expression<Int?>("forks_count")
    
    internal static let forks_url = Expression<String?>("forks_url")
    internal static let full_name = Expression<String?>("full_name")
    internal static let git_commits_url = Expression<String?>("git_commits_url")
    internal static let git_refs_url = Expression<String?>("git_refs_url")
    internal static let git_tags_url = Expression<String?>("git_tags_url")
    internal static let git_url = Expression<String?>("git_url")
    internal static let has_downloads = Expression<Bool?>("has_downloads")
    internal static let has_projects = Expression<Bool?>("has_projects")
    internal static let has_issues = Expression<Bool?>("has_issues")
    internal static let has_pages = Expression<Bool?>("has_pages")
    internal static let has_wiki = Expression<Bool?>("has_wiki")
    
    internal static let homepage = Expression<String?>("homepage")
    internal static let hooks_url = Expression<String?>("hooks_url")
    internal static let html_url = Expression<String?>("html_url")
    internal static let repoId = Expression<Int>("id")
    internal static let issue_comment_url = Expression<String?>("issue_comment_url")
    internal static let issue_events_url = Expression<String?>("issue_events_url")
    internal static let issues_url = Expression<String?>("issues_url")
    internal static let keys_url = Expression<String?>("keys_url")
    internal static let labels_url = Expression<String?>("labels_url")
    internal static let language = Expression<String?>("language")
    
    internal static let languages_url = Expression<String?>("languages_url")
    internal static let merges_url = Expression<String?>("merges_url")
    internal static let milestones_url = Expression<String?>("milestones_url")
    internal static let mirror_url = Expression<String?>("mirror_url")
    internal static let name = Expression<String?>("name")
    internal static let notifications_url = Expression<String?>("notifications_url")
    internal static let open_issues = Expression<Int?>("open_issues")
    internal static let open_issues_count = Expression<Int?>("open_issues_count")
    /// owner id去追踪owner(ObjUser)
    internal static let owner = Expression<Int?>("owner")
    internal static let owner_login = Expression<String?>("owner_login")
    internal static let owner_avatar_url = Expression<String?>("owner_avatar_url")
    
    //ObjPermissions
    internal static let permissions = Expression<String?>("permissions")
    
    internal static let cprivate = Expression<Bool?>("private")//private同关键字冲突，加c前缀
    internal static let pulls_url = Expression<String?>("pulls_url")
    internal static let pushed_at = Expression<String?>("pushed_at")
    internal static let releases_url = Expression<String?>("releases_url")
    internal static let size = Expression<Int?>("size")
    internal static let ssh_url = Expression<String?>("ssh_url")
    internal static let stargazers_count = Expression<Int?>("stargazers_count")
    internal static let stargazers_url = Expression<String?>("stargazers_url")
    internal static let statuses_url = Expression<String?>("statuses_url")
    internal static let subscribers_url = Expression<String?>("subscribers_url")
    
    internal static let subscription_url = Expression<String?>("subscription_url")
    internal static let svn_url = Expression<String?>("svn_url")
    internal static let tags_url = Expression<String?>("tags_url")
    internal static let teams_url = Expression<String?>("teams_url")
    internal static let trees_url = Expression<String?>("trees_url")
    internal static let updated_at = Expression<String?>("updated_at")
    internal static let url = Expression<String?>("url")
    internal static let watchers = Expression<Int?>("watchers")
    internal static let watchers_count = Expression<Int?>("watchers_count")
    internal static let subscribers_count = Expression<Int?>("subscribers_count")
    
    //以下字段为单独增加
    internal static let star_tags = Expression<SQLite.Blob?>("star_tags")
    internal static let star_lists = Expression<SQLite.Blob?>("star_lists")
    internal static let watched = Expression<Bool?>("watched")
    internal static let starred = Expression<Bool?>("starred")
    internal static let starred_at = Expression<String?>("starred_at")

}

// MARK: - 创建表格
extension SQLStars {
    
    /// 创建Star Repos
    static func crateStarReposTable() {
        if retryCount > 3 {
            return
        }
        
        do {
            try SQLManager.githubDb.run(starReposTable.create(ifNotExists: true) { (t) in
                t.column(repoId, primaryKey: true)
                
                t.column(archive_url)
                t.column(assignees_url)
                t.column(blobs_url)
                t.column(branches_url)
                t.column(clone_url)
                t.column(collaborators_url)
                t.column(comments_url)
                t.column(commits_url)
                t.column(compare_url)
                t.column(contents_url)
                
                t.column(contributors_url)
                t.column(created_at)
                t.column(default_branch)
                t.column(deployments_url)
                t.column(description)
                t.column(downloads_url)
                t.column(events_url)
                t.column(fork)
                t.column(forks)
                t.column(forks_count)
                
                t.column(forks_url)
                t.column(full_name)
                t.column(git_commits_url)
                t.column(git_refs_url)
                t.column(git_tags_url)
                t.column(git_url)
                t.column(has_downloads)
                t.column(has_projects)
                t.column(has_issues)
                t.column(has_pages)
                t.column(has_wiki)
                
                t.column(homepage)
                t.column(hooks_url)
                t.column(html_url)
                t.column(issue_comment_url)
                t.column(issue_events_url)
                t.column(issues_url)
                t.column(keys_url)
                t.column(labels_url)
                t.column(language)
                
                t.column(languages_url)
                t.column(merges_url)
                t.column(milestones_url)
                t.column(mirror_url)
                t.column(name)
                t.column(notifications_url)
                t.column(open_issues)
                t.column(open_issues_count)
                t.column(owner)
                t.column(owner_login)
                t.column(owner_avatar_url)
                t.column(permissions)
                
                t.column(cprivate)
                t.column(pulls_url)
                t.column(pushed_at)
                t.column(releases_url)
                t.column(size)
                t.column(ssh_url)
                t.column(stargazers_count)
                t.column(stargazers_url)
                t.column(statuses_url)
                t.column(subscribers_url)
                
                t.column(subscription_url)
                t.column(svn_url)
                t.column(tags_url)
                t.column(teams_url)
                t.column(trees_url)
                t.column(updated_at)
                t.column(url)
                t.column(watchers)
                t.column(watchers_count)
                t.column(subscribers_count)
                
                t.column(star_tags)
                t.column(star_lists)
                t.column(starred)
                t.column(watched)
                t.column(starred_at)
            })
            
            /// 新增starred_at列，注意以后新增需要升级
            let existStarredAtColumn = try SQLManager.githubDb.exists(column: "starred_at", in: starTableName)
            if !existStarredAtColumn {
                try SQLManager.githubDb.run(starReposTable.addColumn(starred_at))
            }
            
        } catch {
            retryCount += 1
            crateStarReposTable()
            print(error)
        }
    }
}

// MARK: - 工具方法
extension SQLStars {
    
    static func convertObjRepos(item: Row) -> ObjRepos {
        
        let repo = ObjRepos()
        repo.id = item[repoId]
        repo.archive_url = item[archive_url]
        repo.assignees_url = item[assignees_url]
        repo.blobs_url = item[blobs_url]
        repo.branches_url = item[branches_url]
        repo.collaborators_url = item[collaborators_url]
        repo.comments_url = item[comments_url]
        repo.commits_url = item[commits_url]
        repo.compare_url = item[compare_url]
        repo.contents_url = item[contents_url]
        
        repo.contributors_url = item[contributors_url]
        repo.created_at = item[created_at]
        repo.default_branch = item[default_branch]
        repo.deployments_url = item[deployments_url]
        repo.cdescription = item[description]
        repo.downloads_url = item[downloads_url]
        repo.events_url = item[events_url]
        repo.fork = item[fork]
        repo.forks = item[forks]
        repo.forks_count = item[forks_count]
        
        repo.forks_url = item[forks_url]
        repo.full_name = item[full_name]
        repo.git_commits_url = item[git_commits_url]
        repo.git_refs_url = item[git_refs_url]
        repo.git_tags_url = item[git_tags_url]
        repo.git_url = item[git_url]
        repo.has_downloads = item[has_downloads]
        repo.has_projects = item[has_projects]
        repo.has_issues = item[has_issues]
        repo.has_pages = item[has_pages]
        repo.has_wiki = item[has_wiki]
        
        repo.homepage = item[homepage]
        repo.hooks_url = item[hooks_url]
        repo.html_url = item[html_url]
        repo.issue_comment_url = item[issue_comment_url]
        repo.issue_events_url = item[issue_events_url]
        repo.issues_url = item[issues_url]
        repo.keys_url = item[keys_url]
        repo.labels_url = item[labels_url]
        repo.language = item[language]
        
        repo.languages_url = item[languages_url]
        repo.merges_url = item[merges_url]
        repo.milestones_url = item[milestones_url]
        repo.mirror_url = item[mirror_url]
        repo.name = item[name]
        repo.notifications_url = item[notifications_url]
        repo.open_issues = item[open_issues]
        repo.open_issues_count = item[open_issues_count]
        let objOnwer = ObjUser()
        objOnwer.id =  item[owner]
        objOnwer.login = item[owner_login]
        objOnwer.avatar_url = item[owner_avatar_url]
        repo.owner = objOnwer
//        repo.permissions = item[permissions]
        
        repo.cprivate = item[cprivate]
        repo.pulls_url = item[pulls_url]
        repo.pushed_at = item[pushed_at]
        repo.releases_url = item[releases_url]
        repo.size = item[size]
        repo.ssh_url = item[ssh_url]
        repo.stargazers_count = item[stargazers_count]
        repo.stargazers_url = item[stargazers_url]
        repo.statuses_url = item[statuses_url]
        repo.subscribers_url = item[subscribers_url]
        
        repo.subscription_url = item[subscription_url]
        repo.svn_url = item[svn_url]
        repo.tags_url = item[tags_url]
        repo.teams_url = item[teams_url]
        repo.trees_url = item[trees_url]
        repo.updated_at = item[updated_at]
        repo.url = item[url]
        repo.watchers = item[watchers]
        repo.watchers_count = item[watchers_count]
        repo.subscribers_count = item[subscribers_count]
        
        repo.star_tags = SQLHelper.stringArray(blob: item[star_tags])
        repo.star_lists = SQLHelper.stringArray(blob: item[star_lists])
        repo.watched = item[watched]
        repo.starred = item[starred]
        repo.starred_at = item[starred_at]
        return repo
    }
    
    static func SQLStarReposSetters(repos: ObjRepos, action: SQLiteAction) -> [SQLite.Setter] {
        
        var setters = [
            
            archive_url    <- repos.archive_url,
            assignees_url    <- repos.assignees_url,
            blobs_url    <- repos.blobs_url,
            branches_url    <- repos.branches_url,
            clone_url    <- repos.clone_url,
            collaborators_url    <- repos.collaborators_url,
            comments_url    <- repos.comments_url,
            commits_url    <- repos.commits_url,
            compare_url    <- repos.compare_url,
            contents_url    <- repos.contents_url,
            
            contributors_url    <- repos.contributors_url,
            created_at    <- repos.created_at,
            default_branch    <- repos.default_branch,
            deployments_url    <- repos.deployments_url,
            description    <- repos.cdescription,
            downloads_url    <- repos.downloads_url,
            events_url    <- repos.events_url,
            fork    <- repos.fork,
            forks    <- repos.forks,
            forks_count    <- repos.forks_count,
            
            forks_url    <- repos.forks_url,
            full_name    <- repos.full_name,
            git_commits_url    <- repos.git_commits_url,
            git_refs_url    <- repos.git_refs_url,
            git_tags_url    <- repos.git_tags_url,
            git_url    <- repos.git_url,
            has_downloads    <- repos.has_downloads,
            has_projects    <- repos.has_projects,
            has_issues    <- repos.has_issues,
            has_pages    <- repos.has_pages,
            has_wiki    <- repos.has_wiki,
            
            homepage    <- repos.homepage,
            hooks_url    <- repos.hooks_url,
            html_url    <- repos.html_url,
            issue_comment_url    <- repos.issue_comment_url,
            issue_events_url    <- repos.issue_events_url,
            issues_url    <- repos.issues_url,
            keys_url    <- repos.keys_url,
            labels_url    <- repos.labels_url,
            language    <- repos.language,
            
            languages_url    <- repos.languages_url,
            merges_url    <- repos.merges_url,
            milestones_url    <- repos.milestones_url,
            mirror_url    <- repos.mirror_url,
            name    <- repos.name,
            notifications_url    <- repos.notifications_url,
            open_issues    <- repos.open_issues,
            open_issues_count    <- repos.open_issues_count,
            owner <- repos.owner!.id!,
            owner_login <- repos.owner!.login,
            owner_avatar_url <- repos.owner?.avatar_url,

            cprivate    <- repos.cprivate,
            pulls_url    <- repos.pulls_url,
            pushed_at    <- repos.pushed_at,
            releases_url    <- repos.releases_url,
            size    <- repos.size,
            ssh_url    <- repos.ssh_url,
            stargazers_count    <- repos.stargazers_count,
            stargazers_url    <- repos.stargazers_url,
            statuses_url    <- repos.statuses_url,
            subscribers_url    <- repos.subscribers_url,
            
            subscription_url    <- repos.subscription_url,
            svn_url    <- repos.svn_url,
            tags_url    <- repos.tags_url,
            teams_url    <- repos.teams_url,
            trees_url    <- repos.trees_url,
            updated_at    <- repos.updated_at,
            url    <- repos.url,
            watchers    <- repos.watchers,
            watchers_count    <- repos.watchers_count,
            subscribers_count    <- repos.subscribers_count,

            starred_at <- repos.starred_at
        ]
        
        let idSetter: SQLite.Setter = repoId <- repos.id!
        //以下自增的字段均通过不同手段更新
        let watchedSetter: SQLite.Setter = watched    <- repos.watched
        let starredSetter: SQLite.Setter = starred    <- repos.starred
        let startagsSetter: SQLite.Setter = star_tags <-  SQLHelper.SQLBlob(stringarray: repos.star_tags)
        let starlistSetter: SQLite.Setter = star_lists <- SQLHelper.SQLBlob(stringarray: repos.star_lists)

        switch action {
        case .insert:
            setters.append(idSetter)
            setters.append(watchedSetter)
            setters.append(starredSetter)
            setters.append(starlistSetter)
            setters.append(startagsSetter)
        default:
            break
        }
        
        return setters
    }
}
