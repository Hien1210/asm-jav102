package com.petcare.model;

import java.io.Serializable;
import java.util.List;

public class ServiceCard implements Serializable {
    private String id;
    private String badgeText;
    private String badgeTheme;
    private String priceTag;
    private String priceTheme;
    private String title;
    private String description;
    private String image;
    private List<String> bullets;
    private String bulletTheme;
    private String actionText;
    private String actionUrl;
    private String actionTheme;
    private boolean external;

    public ServiceCard() {
    }

    public ServiceCard(String id, String badgeText, String badgeTheme, String priceTag, String priceTheme,
                       String title, String description, String image, List<String> bullets, String bulletTheme,
                       String actionText, String actionUrl, String actionTheme, boolean external) {
        this.id = id;
        this.badgeText = badgeText;
        this.badgeTheme = badgeTheme;
        this.priceTag = priceTag;
        this.priceTheme = priceTheme;
        this.title = title;
        this.description = description;
        this.image = image;
        this.bullets = bullets;
        this.bulletTheme = bulletTheme;
        this.actionText = actionText;
        this.actionUrl = actionUrl;
        this.actionTheme = actionTheme;
        this.external = external;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getBadgeText() { return badgeText; }
    public void setBadgeText(String badgeText) { this.badgeText = badgeText; }

    public String getBadgeTheme() { return badgeTheme; }
    public void setBadgeTheme(String badgeTheme) { this.badgeTheme = badgeTheme; }

    public String getPriceTag() { return priceTag; }
    public void setPriceTag(String priceTag) { this.priceTag = priceTag; }

    public String getPriceTheme() { return priceTheme; }
    public void setPriceTheme(String priceTheme) { this.priceTheme = priceTheme; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public List<String> getBullets() { return bullets; }
    public void setBullets(List<String> bullets) { this.bullets = bullets; }

    public String getBulletTheme() { return bulletTheme; }
    public void setBulletTheme(String bulletTheme) { this.bulletTheme = bulletTheme; }

    public String getActionText() { return actionText; }
    public void setActionText(String actionText) { this.actionText = actionText; }

    public String getActionUrl() { return actionUrl; }
    public void setActionUrl(String actionUrl) { this.actionUrl = actionUrl; }

    public String getActionTheme() { return actionTheme; }
    public void setActionTheme(String actionTheme) { this.actionTheme = actionTheme; }

    public boolean isExternal() { return external; }
    public void setExternal(boolean external) { this.external = external; }
}

