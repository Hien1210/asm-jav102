package com.petcare.model;

import java.io.Serializable;

public class ReviewItem implements Serializable {
    private String timeAgo;
    private String quote;
    private String avatar;
    private String authorName;
    private String branchName;

    public ReviewItem() {
    }

    public ReviewItem(String timeAgo, String quote, String avatar, String authorName, String branchName) {
        this.timeAgo = timeAgo;
        this.quote = quote;
        this.avatar = avatar;
        this.authorName = authorName;
        this.branchName = branchName;
    }

    public String getTimeAgo() { return timeAgo; }
    public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }

    public String getQuote() { return quote; }
    public void setQuote(String quote) { this.quote = quote; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
}

