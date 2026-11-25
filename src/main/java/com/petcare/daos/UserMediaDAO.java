package com.petcare.daos;

import com.petcare.models.Users;

import java.sql.SQLException;

public interface UserMediaDAO {

    /**
     * Returns a 2-element array: [avatarUrl, bannerUrl].
     * Implementations should fail-open (returning [null, null]) if dbo.UserMedia
     * has not yet been migrated on the target database.
     */
    String[] findByUserId(int userId);

    default void hydrate(Users user) {
        if (user == null) {
            return;
        }
        String[] media = findByUserId(user.getUserId());
        user.setAvatarUrl(media != null && media.length > 0 ? media[0] : null);
        user.setBannerUrl(media != null && media.length > 1 ? media[1] : null);
        user.setMediaLoaded(true);
    }

    void updateAvatarUrl(int userId, String avatarUrl) throws SQLException;

    void updateBannerUrl(int userId, String bannerUrl) throws SQLException;
}
